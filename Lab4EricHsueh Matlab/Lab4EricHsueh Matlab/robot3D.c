#include <matrix.h>
#include <mex.h>
#include <pthread.h>
#include <GL/glut.h>
#include <SDL/SDL.h>
#include <stdint.h>
#include <sys/select.h>
#include <stdarg.h>
#include <tmwtypes.h>
#include <math.h>

static int initted=0;
static int called=0;
static pthread_t thread=0;
static int done=0;
static GLuint window=0;
static pid_t child=0;
static int frame_delay=50;

char path[1024]="/home/dsk06/cscrs/c340/web_docs/labs/labAssign3/data/";

int ww=640;
int wh=480;
float cposx=0,cposy=0,cposz=-5;
float rx=20,ry=0,rz=0;
GLuint bdown;
GLint mpos[2];
int wireframe=false;
int lighting=true;
int drawbones=false;
double fps=0;
GLuint texid;
int debug=0;

int fd[2];

typedef struct _point_t{
  float pos[3];
  float col[3];
  struct _point_t * next;
}point_t;

typedef struct _bone_t{
  char name[32];
  double rest[4][4];
  double M[4][4];
  double T[4][4];

  int   flipped;
  double  ang[3];
  char    dof[3];
  int       ndof;
  int      nkids;
  double     len;/* Only used to update transform */
  struct _bone_t * parent;
  struct _bone_t * children[12];
}bone_t;

typedef struct _bone_weight_t{
  short   bone;
  float weight;
}bone_weight_t;

typedef struct _vertex_t{
  float   pos[3];
  float   apos[3];
  float   an[3];
  float    n[3];
  int   nweights;
  bone_weight_t weights[32];
}vertex_t;

typedef struct _tri_t{
  int vi[3];
  int ti[3];
}tri_t;

typedef float vec2[2];
typedef float vec3[2];

void vec3_sub(float res[3],float a[3],float b[3]){
  res[0]=a[0]-b[0];
  res[1]=a[1]-b[1];
  res[2]=a[2]-b[2];
}

void vec3_cross(float res[3],float a[3],float b[3]){
  res[0]=a[1]*b[2]-a[2]*b[1];
  res[1]=-a[0]*b[2]+a[2]*b[0];
  res[2]=a[0]*b[1]-a[1]*b[0];
}

void vec3_normalize(float r[3]){
  double l=sqrt(r[0]*r[0]+r[1]*r[1]+r[2]*r[2]);
  r[0]/=l;
  r[1]/=l;
  r[2]/=l;
}

void trinorm(float res[3],float v1[3],float v2[3],float v3[3]){
  float e1[3];
  float e2[3];
  vec3_sub(e1,v2,v1);
  vec3_sub(e2,v3,v1);
  vec3_cross(res,e1,e2);
}


tri_t * tris = 0;
vertex_t * verts = 0;
vec2 * tverts = 0;

int nverts = 0;
int ntris = 0;
int ntverts =0;

vec3 * record=0;
int nrecord=0;
int maxrecord=0;

/**
   Assume zeroth bone is the root.
*/
bone_t ** bones = 0;
int nbones = 0;

point_t * points = 0;
point_t *  lines = 0;

enum messages_t{
  FRAME_DELAY,
  BONE_PARAMS,
  APPEND_POINTS,
  APPEND_LINES,
  CLEAR,
  RECORD,
  RECORD_CLEAR
};

void init_mesh(){
  char name[1024];
  snprintf(name,1024,"%sadam.obj",path);
  
  FILE * file=fopen(name,"r");
  char line[1024];
  int ti=0,vi=0;
  int tvi=0;
  int nweight=0;
  int i=0;

  if(!file){
    printf("error opening geometry\n");
    return;
  }

  nverts=ntverts=0;
  ntris=0;

  while(fgets(line,1024,file)){
    if(line[0]=='v'){
      if(line[1]==' ')nverts++;
      else if(line[1]=='t')ntverts++;
      else if(line[2]=='w')nweight++;
    }
    else if(line[0]=='f'){
      ntris++;
    }
  }
  fseek(file,0,SEEK_SET);

  tris = malloc(sizeof(tri_t)*ntris);
  verts = malloc(sizeof(vertex_t)*nverts);
  tverts = malloc(sizeof(vec2)*ntverts);

  while(fgets(line,1024,file)){
    if(line[0]=='v'){
      float f[4];
      if(line[1]==' '){
	sscanf(line+2,"%f %f %f",f,f+1,f+2);
	verts[vi].pos[0]=f[0];
	verts[vi].pos[1]=f[1];
	verts[vi].pos[2]=f[2];
	verts[vi].nweights=0;
	vi++;
      }
      else if(line[1]=='t'){
	sscanf(line+3,"%f %f",f,f+1);
	tverts[tvi][0]=f[0];
	tverts[tvi][1]=f[1];
	tvi++;
      }
      else if(line[1]=='w'){
	int vert;
	int bone;
	float weight;
	sscanf(line+3,"%d %d %f",&vert,&bone,&weight);
	vert--;
	verts[vert].weights[verts[vert].nweights].bone=bone;
	verts[vert].weights[verts[vert].nweights].weight=weight;
	verts[vert].nweights++;
      }
    }
    else if(line[0]=='f'){
      int v[3],t[3];
      int j;
      sscanf(line+2,"%d/%d %d/%d %d/%d",v,t,
	     v+1,t+1,v+2,t+2);
      for(j=0;j<3;j++){
	v[j]--;
	t[j]--;
      }
	
      memcpy(tris[ti].vi,v,sizeof(v));
      memcpy(tris[ti].ti,t,sizeof(t));
      ti++;
    }
  }
  for(i=0;i<nverts;i++){
    verts[i].n[0]=0;
    verts[i].n[1]=0;
    verts[i].n[2]=0;
  }
  for(i=0;i<ntris;i++){
    vec3 n;
    int j;
    trinorm(n,
	    verts[tris[i].vi[0]].pos,
	    verts[tris[i].vi[1]].pos,
	    verts[tris[i].vi[2]].pos);
    for(j=0;j<3;j++){
      verts[tris[i].vi[0]].n[j]+=n[j];
      verts[tris[i].vi[1]].n[j]+=n[j];
      verts[tris[i].vi[2]].n[j]+=n[j];
    }
  }
  for(i=0;i<nverts;i++){
    vec3_normalize(verts[i].n);
  }

  fclose(file);

  snprintf(name,1024,"%sadam.ppm",path);
  file=fopen(name,"rb");
  if(file){
    if(debug)
      fprintf(stderr,"About to read image\n");

    int w,h,max;
    char line[1024];
    
    fgets(line,1024,file);
    fgets(line,1024,file);
    sscanf(line,"%d %d",&w,&h);
    fgets(line,1024,file);
    sscanf(line,"%d",&max);

    if(debug)
      printf("reading image %d %d %d\n",w,h);
    char * data=malloc(w*h*3);
    
    
    fread(data,3,w*h,file);

    glGenTextures(1,&texid);
    glBindTexture(GL_TEXTURE_2D,texid);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MAG_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_MIN_FILTER,GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_S,GL_CLAMP);
    glTexParameteri(GL_TEXTURE_2D,GL_TEXTURE_WRAP_T,GL_CLAMP);
    glTexEnvi(GL_TEXTURE_ENV,GL_TEXTURE_ENV_MODE,GL_MODULATE);

    
    glTexImage2D(GL_TEXTURE_2D,0,GL_RGB,w,h,0,GL_RGB,GL_UNSIGNED_BYTE,data);
    free(data);
    
    fclose(file);
  }
}

void matrix_print(double m[4][4],const char * str){
  int i=0,j=0;
  printf("%s=[ ",str);
  for(i=0;i<4;i++){
    for(j=0;j<4;j++){
      printf("%g ",m[i][j]);
    }
    if(i<3)
      printf("\n");
  }
  printf("]\n");

}

void matrix_tform_point(float pr[3],double m[4][4],float pin[3]){
  double res[3];
  int i;

  for(i=0;i<3;i++){
    res[i]=m[i][0]*pin[0]+m[i][1]*pin[1]+m[i][2]*pin[2]+m[i][3];
  }
  pr[0]=res[0];
  pr[1]=res[1];
  pr[2]=res[2];
}

void matrix_eye(double m[4][4]){
  int i=0,j=0;
  for(i=0;i<4;i++)
    for(j=0;j<4;j++)
      m[i][j]=(i==j);
}

void matrix_rot(double m[4][4],char r,double ang){
  double c=cos(ang);
  double s=sin(ang);
  matrix_eye(m);
  if(r==0 || r=='x' || r=='X'){
    m[1][1]= c;
    m[1][2]=-s;
    m[2][1]= s;
    m[2][2]= c;
  }
  else if(r==1 || r=='y' || r=='Y'){
    m[0][0]= c;
    m[0][2]= s;
    m[2][0]=-s;
    m[2][2]= c;
  }
  else if(r==2 || r=='z' || r=='Z'){
    m[0][0]= c;
    m[0][1]=-s;
    m[1][0]= s;
    m[1][1]= c;
  }
}
void matrix_transpose(double tr[4][4],double m[4][4]){
  double res[4][4];
  int i,j;
  for(i=0;i<4;i++){
    for(j=0;j<4;j++){
      res[i][j]=m[j][i];
    }
  }
  memcpy(tr,res,sizeof(res));
}

void matrix_eucinv(double einv[4][4],double m[4][4]){
  int j;
  matrix_transpose(einv,m);
  einv[3][0]=einv[3][1]=einv[3][2]=0;
  einv[0][3]=einv[1][3]=einv[2][3]=0;
  for(j=0;j<3;j++){
    int k;
    for(k=0;k<3;k++)
      einv[j][3]-=(einv[j][k]*m[k][3]);
  }
}

void matrix_translate(double m[4][4],double x,double y,double z){
  int i=0,j=0;
  for(i=0;i<4;i++)
    for(j=0;j<4;j++)
      m[i][j]=(i==j);
  m[0][3]=x;
  m[1][3]=y;
  m[2][3]=z;
}
void matrix_mult(double mout[4][4],double a[4][4],double b[4][4]){
  double res[4][4];
  int i,j,k;
  memset(res,0,sizeof(res));
  for(i=0;i<4;i++){
    for(j=0;j<4;j++){
      double sum=0;
      for(k=0;k<4;k++){
	sum+=a[i][k]*b[k][j];
      }
      res[i][j]=sum;
    }
  }
  memcpy(mout,res,sizeof(res));
}

bone_t *  bone_alloc(){
  bone_t * bone = malloc(sizeof(bone_t));
  memset(bone,0,sizeof(bone_t));
  matrix_eye(bone->M);
  bone->ndof=3;
  bone->dof[0]='x';
  bone->dof[1]='y';
  bone->dof[2]='z';
  return bone;
}

void bone_add_child(bone_t * b,bone_t * c){
  b->children[b->nkids++]=c;
  c->parent=b;
}

void bone_get_anim(bone_t * b,double T[4][4]){
  double M[4][4];
  int i;
  
  matrix_eye(T);
  for(i=0;i<b->ndof;i++){
    matrix_rot(M,b->dof[i],b->ang[i]);
    matrix_mult(T,M,T);
  }
  /*
  if(b->flipped){
    double flipper[4][4];
    matrix_rot(flipper,'x',M_PI);
    matrix_mult(T,T,flipper);
    matrix_mult(T,flipper,T);
  }
  */
}

void bone_init_rest(bone_t * b){
  memcpy(b->rest,b->M,sizeof(b->rest));
  if(b->parent){
    matrix_mult(b->rest,b->parent->rest,b->M);
  }
}

void bone_init_tform(bone_t * b){
  double A[4][4];
  memcpy(b->T,b->M,sizeof(b->T));
  if(b->parent)
    matrix_mult(b->T,b->parent->T,b->T);
  
  bone_get_anim(b,A);
  matrix_mult(b->T,b->T,A);
}


void init_bones(){
  char name[1024];
  FILE * file;
  char line[1024];
  int i=0;
  nbones=0;

  snprintf(name,1024,"%sadam.txt",path);
  file=fopen(name,"r");

  if(!file){
    printf("file doesn't exist\n");
    return;
  }

  while(fgets(line,1023,file)){
    int dummy;
    if(sscanf(line,"%d",&dummy)){
      nbones++;
    }
  }

  fseek(file,0,SEEK_SET);

  bones = malloc(sizeof(bone_t *)*nbones);

  for(i=0;i<nbones;i++){
    bones[i] = bone_alloc();
  }

  i=0;
  while(fgets(line,1023,file)){
    char name[64];
    double M[16];
    double len;
    int parent,id;
    int flipped;
    M[12]=0;
    M[13]=0;
    M[14]=0;
    M[15]=1;
    
    if(sscanf(line,"%d %s %d %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %lf %d",
	      &id,name,&parent,
	      M,M+1,M+2,M+3,
	      M+4,M+5,M+6,M+7,
	      M+8,M+9,M+10,M+11,&len,&flipped)){
      char * rs[3];
      int ri;
      memcpy(bones[i]->M,M,sizeof(bones[i]->M));
      bones[i]->len=len;
      bones[i]->flipped=flipped;

      rs[0]=strstr(line,"rx(");
      rs[1]=strstr(line,"ry(");
      rs[2]=strstr(line,"rz(");
      
      bones[i]->ndof=0;

      strcpy(bones[i]->name,name);

      for(ri=0;ri<2;ri++){
	int mini=ri;
	int j=ri+1;
	for(;j<3;j++){
	  if(rs[j]<rs[mini])
	    mini=j;
	}
	char * back=rs[mini];
	rs[mini]=rs[ri];
	rs[ri]=back;
      }
      for(ri=0;ri<3;ri++){
	if(rs[ri]){
	  bones[i]->dof[bones[i]->ndof++]=rs[ri][1];
	}
      }
      if(debug)printf("bn{%d}=\'%s\';bdof(%d)=%d;%% flipped:%d\n",i+1,name,i+1,bones[i]->ndof,flipped);

      if(parent>=0){
	double T[4][4];
	matrix_translate(T,0,bones[parent]->len,0);
	matrix_mult(bones[i]->M,T,bones[i]->M);
	bone_add_child(bones[parent],bones[i]);
      }
      i++;
    }
  }
  /*
    Have to do this as the bone geometry came from
    elsewhere.
  */
  if(1)
  {
    double m[4][4];
    matrix_rot(m,'x',M_PI);
    for(i=0;i<nbones;i++){
      
      if(bones[i]->flipped){
	int j;
	matrix_mult(bones[i]->M,bones[i]->M,m);

	for(j=0;j<bones[i]->nkids;j++){
	  matrix_mult(bones[i]->children[j]->M,m,bones[i]->children[j]->M);
	}
      }
    }
  }

  for(i=0;i<nbones;i++)
    bone_init_rest(bones[i]);

  for(i=0;i<nbones;i++){
    bone_init_tform(bones[i]);
  }
  fclose(file);
}

void draw_bones(){
  int i=0,j=0;

  glPushMatrix();
 
  for(i=0;i<nbones;i++){
    double M[4][4];
    
    glPushMatrix();
    matrix_transpose(M,bones[i]->T);
    glMultMatrixd((double*)M);
    
    for(j=0;j<3;j++){
      double s=0.1;
      glColor3f(j==0,j==1,j==2);
      glBegin(GL_LINES);
      glVertex3f(0,0,0);
      glVertex3f(s*(j==0),s*(j==1),s*(j==2));
      glEnd();
    }
    glPopMatrix();
  }

  glPopMatrix();
}

point_t * append_list(point_t * p,float pos[3],float col[3]){
  point_t * pnew=malloc(sizeof(point_t));
  
  memcpy(pnew->pos,pos,sizeof(float)*3);
  memcpy(pnew->col,col,sizeof(float)*3);
  
  pnew->next=p;
  return pnew;
}

point_t * free_list(point_t * p){
  while(p){
    point_t * pcur=p;
    p=p->next;
    free(pcur);
  }
  return 0;
}

int listener_thread(){
  struct timeval tv;
  fd_set set;
  
  FD_ZERO(&set);
  FD_SET(fd[0],&set);
  
  tv.tv_sec=0;
  tv.tv_usec=1;
  int retval = select(fd[1]+1,&set,0,0,&tv);
  
  if(retval<0)perror("select");
  else if(retval>0){
    uint32_t message,length;
    read(fd[0],&message,sizeof(message));
    read(fd[0],&length,sizeof(length));
   
    if(message==FRAME_DELAY){
      read(fd[0],&frame_delay,sizeof(int));
    }
    else if(message==BONE_PARAMS){
      double * parms=malloc(length);
      uint32_t nparms=length/8;
      int i;
      int bi=0;
      int pi=0;
      read(fd[0],parms,length);
      
      if(nparms==8){
	/*
	  Assume left leg followed by right leg
	  Left  is:6,7,8,14
	  Right is:9,10,11,15
	*/
	i=0;
	bones[4]->ang[0]=parms[i++];
	bones[4]->ang[1]=parms[i++];
	bones[4]->ang[2]=parms[i++];
	bones[7]->ang[0]=parms[i++];

	bones[5]->ang[0]=parms[i++];
	bones[5]->ang[1]=parms[i++];
	bones[5]->ang[2]=parms[i++];
	bones[8]->ang[0]=parms[i++];
      }
      else{
	for(i=0,bi=0;bi<nbones;bi++){
	  for(pi=0;pi<bones[bi]->ndof;pi++){
	    /*printf("setting %d %d to %f\n",bi,pi,parms[i]);*/
	    bones[bi]->ang[pi]=parms[i++];
	    
	    if(i>=nparms)break;
	  }
	  if(i>=nparms)break;
	}
      }

      for(i=0;i<nbones;i++){
	bone_init_tform(bones[i]);
      }
      free(parms);
    }
    else if(message==CLEAR){
      points=free_list(points);
      lines=free_list(lines);
    }
    else if(message==APPEND_POINTS || 
	    message==APPEND_LINES){
      point_t ** ptr=&points;
      if(message==APPEND_LINES)
	ptr=&lines;

      int npts=length/3/8;
      int i;
      float col[3]={1,1,1};
      float pos[3];
      for(i=0;i<npts;i++){
	double pd[3];
	read(fd[0],&pd,3*sizeof(double));
	pos[0]=pd[0];
	pos[1]=pd[1];
	pos[2]=pd[2];
	*ptr=append_list(*ptr,pos,col);
      }
    }
    else if(message==RECORD){
      /*
	Keep track of animated position of the feet 
	relative to the root.

	lfoot=10, rfoot=11
      */
      if(!record || !maxrecord){
	if(record)free(record);

	maxrecord=10000;
	record=malloc(2*maxrecord*sizeof(vec3));
	nrecord=0;
      }
      if(nrecord<maxrecord){
	int j;
	double T[4][4];
	float pl[3];
	float pr[3];
	float blue[3]={0,0,1};
	float red[3]={1,0,0};

	for(j=0;j<3;j++){
	  pl[j]=bones[10]->T[j][3];
	  pr[j]=bones[11]->T[j][3];
	}

	points=append_list(points,pl,blue);
	lines=append_list(lines,pr,red);


	matrix_eucinv(T,bones[0]->T);
	matrix_tform_point(pl,T,pl);
	matrix_tform_point(pr,T,pr);

	
	for(j=0;j<3;j++){
	  record[2*nrecord][j]=pl[j];
	  record[2*nrecord+1][j]=pr[j];
	}
	nrecord++;
      }
    }
    else if(message==RECORD_CLEAR){
      /*
	Keep track of animated position of the feet 
	relative to the root.

	lfoot=10, rfoot=11
      */
      if(record){
	int i,j;
	int inds[6]={4,7,10,5,8,11};
	double T[4][4];
	
	matrix_eucinv(T,bones[0]->rest);
	
	for(i=0;i<6;i++){
	  if(i==0 || i==3){
	    double M[4][4];
	    matrix_mult(M,T,bones[inds[i]]->rest);
	    /*matrix_print(bones[inds[i]]->rest,bones[inds[i]]->name);*/
	    matrix_print(M,bones[inds[i]]->name);
	  }
	  else
	    matrix_print(bones[inds[i]]->M,bones[inds[i]]->name);
	}
	
	printf("L=[");
	for(j=0;j<3;j++){
	  for(i=0;i<nrecord;i++){
	    printf("%g ",record[2*i][j]);
	  }
	  printf(";");
	}
	printf("];\n");
	
	printf("R=[");
	for(j=0;j<3;j++){
	  for(i=0;i<nrecord;i++){
	    printf("%g ",record[2*i+1][j]);
	  }
	  printf(";");
	}
	printf("];\n");


	free(record);
	nrecord=0;
	maxrecord=0;
	record=0;
      }
    }
    return true;
  }
  return false;
}

void drawString(float x,float y,char * fmt,...){
  char str[1024];
  va_list ap;

  va_start(ap, fmt);
  vsnprintf(str,1024,fmt,ap);
  va_end(ap);

  glRasterPos2f(x,y);
  char * c=str;
  while(*c){
    glutBitmapCharacter(GLUT_BITMAP_TIMES_ROMAN_10,*c++);
  }
}

void mouse(GLint button,GLint state,GLint x,GLint y){
  bdown=(state==GLUT_DOWN)?(button+1):0;

  mpos[0]=x;
  mpos[1]=y;
}

void motion(GLint x,GLint y){
  double dx=(double)(x-mpos[0])/(double)ww;
  double dy=(double)(y-mpos[1])/(double)ww;

  if(bdown==1){
    ry+=dx*30;
    rx+=dy*30;
  }
  if(bdown==3){
   cposz+=dy;
  }

  mpos[0]=x;
  mpos[1]=y;
}

void reshape(int x,int y){
  ww=x;
  wh=y;
  glViewport(0,0,ww,wh);
}

void setup_lights(){
  float white[]={0.4,0.4,0.4,1};
  float pos[]={0,0,0,1};
  int i;
  for(i=0;i<3;i++){
    pos[i]=4;
    glEnable(GL_LIGHT0+i);
    glLightfv(GL_LIGHT0+i,GL_DIFFUSE,white);
    glLightfv(GL_LIGHT0+i,GL_POSITION,pos);
    pos[i]=0;
  }
  glMatrixMode(GL_MODELVIEW);
  glPushMatrix();
  glLoadIdentity();
  glEnable(GL_LIGHT3);
  glLightfv(GL_LIGHT3,GL_DIFFUSE,white);
  glLightfv(GL_LIGHT3,GL_POSITION,pos);
  glPopMatrix();
  

  if(lighting)glEnable(GL_LIGHTING);
}

double accum_tform(float apos[3],
		   double M[4][4],
		   double weight,
		   float p[3],float last){
  int i;
  for(i=0;i<3;i++){
    apos[i]+=weight*(M[i][0]*p[0]+M[i][1]*p[1]+M[i][2]*p[2]+M[i][3]*last);
  }
  return weight;
}

void draw_mesh(){
  int i;
  double (* mats)[4][4]=malloc(sizeof(double)*4*4*nbones);;

  /*matrix_transpose(mm,mm);*/
  glPushMatrix();
  /*glMultMatrixd((double *)mm);*/

  for(i=0;i<nbones;i++){
    double Einv[4][4];
    
    matrix_eucinv(Einv,bones[i]->rest);
    matrix_mult(mats[i],bones[i]->T, Einv);
  }
  for(i=0;i<nverts;i++){
    int j;
    double w=0;
    verts[i].apos[0]=0;
    verts[i].apos[1]=0;
    verts[i].apos[2]=0;

    verts[i].an[0]=0;
    verts[i].an[1]=0;
    verts[i].an[2]=0;
    
    for(j=0;j<verts[i].nweights;j++){
      w+=accum_tform(verts[i].apos,
		     mats[verts[i].weights[j].bone],
		     verts[i].weights[j].weight,
		     verts[i].pos,1);
      accum_tform(verts[i].an,
		  mats[verts[i].weights[j].bone],
		  verts[i].weights[j].weight,
		  verts[i].n,0);
    }
    if(w>0){
      verts[i].apos[0]/=w;
      verts[i].apos[1]/=w;
      verts[i].apos[2]/=w;
    }
  }

  glEnable(GL_TEXTURE_2D);
  glBindTexture(GL_TEXTURE_2D,texid);

  glBegin(GL_TRIANGLES);
  for(i=0;i<ntris;i++){
    int j=0;
    for(;j<3;j++){
      glTexCoord2fv(tverts[tris[i].ti[j]]);
      glNormal3fv(verts[tris[i].vi[j]].an);
      glVertex3fv(verts[tris[i].vi[j]].apos);
    }
  }
  glEnd();
  glDisable(GL_TEXTURE_2D);

  glPopMatrix();

  free(mats);
}

void draw_points(){
  int cnt=0;
  point_t * p=points;
  glBegin(GL_POINTS);
  while(p){
    glColor3fv(p->col);
    glVertex3fv(p->pos);
    p=p->next;
    cnt++;
  }
  glEnd();
}

void draw_lines(){
  point_t * p=lines;
  glBegin(GL_LINES);
  while(p){
    glColor3fv(p->col);
    glVertex3fv(p->pos);
    p=p->next;
  }
  glEnd();
}

void display(){
  static struct timeval last_time;
  static struct timeval time;
  static int cnt=-1;
  double dtime;

  if(cnt==-1)gettimeofday(&last_time,0);

  if(wireframe) glPolygonMode(GL_FRONT_AND_BACK,GL_LINE);
  else glPolygonMode(GL_FRONT_AND_BACK,GL_FILL);
  
  glClearColor(0.5,0.6,0.95,0);
  glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
  
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  gluPerspective(50,1.333,0.1,1000);
  
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();

  glTranslatef(cposx,cposy,cposz);
  glRotatef(rz,0,0,1);
  glRotatef(rx,1,0,0);
  glRotatef(ry,0,1,0);

  setup_lights();

  draw_mesh();
  /*glutSolidCube(1);
    glTranslatef(0,1,0);
    glutSolidSphere(1,10,10); */

  glDisable(GL_LIGHTING);

  if(drawbones)draw_bones();

  draw_points();
  draw_lines();

  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  glOrtho(0,ww,0,wh,-1,1);
  
  glMatrixMode(GL_MODELVIEW);
  glLoadIdentity();

  glDisable(GL_LIGHTING);
  glColor3f(1,1,1);
  drawString(5,20,"frame delay:%d",frame_delay);
  drawString(5,10,"fps:%5.1f",fps);

  glutSwapBuffers();

  cnt++;
  gettimeofday(&time);
  dtime=((double)(time.tv_sec-last_time.tv_sec))+
    ((double)(time.tv_usec-last_time.tv_usec))/1e6;
  if(dtime>0.5){
    fps=(double)cnt/dtime;
    last_time=time;
    cnt=0;
  }
  /*SDL_GL_SwapBuffers();*/
}

void timerFunc(GLint val){
  int succ=0;
  while(listener_thread() && succ<10)
    succ++;
  
  glutPostRedisplay();
  glutTimerFunc(frame_delay,timerFunc,val);
}

void keys(unsigned char c,GLint x,GLint y){
  switch(c){
  case 'b':
    drawbones=!drawbones;
    break;
  case 'l':
  case 'L':
    lighting=!lighting;
    if(lighting) glEnable(GL_LIGHTING);
    break;
  case 'w':
    wireframe=!wireframe;
    break;
  }
}


void * glutLoop(void * parm){
  static char * av[]={"program"};
  static int ac=1;
  
  glutInit(&ac,av);
  glutInitDisplayMode(GLUT_RGBA|GLUT_DOUBLE|GLUT_DEPTH);
  glutInitWindowSize(ww,wh);
  
  window = glutCreateWindow("glut");
  glutDisplayFunc(display);
  glutReshapeFunc(reshape);
  glutMotionFunc(motion);
  glutMouseFunc(mouse);
  glutKeyboardFunc(keys);

  
  glEnable(GL_COLOR_MATERIAL);
  glColorMaterial(GL_FRONT_AND_BACK,GL_AMBIENT_AND_DIFFUSE);
  glEnable(GL_NORMALIZE);
  glEnable(GL_DEPTH_TEST);
  glLightModeli(GL_LIGHT_MODEL_LOCAL_VIEWER,GL_TRUE);

  init_bones();
  init_mesh();

  glutTimerFunc(frame_delay,timerFunc,0);
  glutMainLoop();
}

void spawnNew(){
  if(child){
    kill(child,9);
    close(fd[1]);/* Close write channel for parent */
  }
  pipe(fd);

  child=fork();
  if(child==0){
    close(fd[1]);
    
    close(0);/* Close stdin */
    
    glutLoop(0);
    exit(0);
  }
  close(fd[0]);/* Parent doesn't need this */
  initted=true;
}

void onexit(){
  if(child)
    kill(child,9);
}

void mexFunction(int nlhs, mxArray *plhs[],
		 int nrhs, const mxArray *prhs[])
{
  char cmd[256];
  if(nrhs < 1){
    mexErrMsgTxt("Not enough input arguments.");
  }
  cmd[0]=0;
  
  
  if(!initted)spawnNew();

  mxClassID cid = mxGetClassID(prhs[0]);
  switch(cid){
  case mxCHAR_CLASS:
    {
      uint32_t message,length;
      mxGetString(prhs[0],cmd,256);
      if(strcmp(cmd,"new")==0){
	spawnNew();
      }
      else if(strcmp(cmd,"set")==0){
	int32_t data=20;
	message=FRAME_DELAY;
	length=4;

	write(fd[1],&message,sizeof(uint32_t));
	write(fd[1],&length,sizeof(uint32_t));
	write(fd[1],&data,sizeof(uint32_t));
      }
      else if(strcmp(cmd,"points")==0){
	int ndims;
	const int * dims;
	if(nrhs<2)mxErrMsgTxt("Need points as 3 x n matrix");
	ndims = mxGetNumberOfDimensions(prhs[1]);
	dims = mxGetDimensions(prhs[1]);
		
	message=APPEND_POINTS;
	length=3*dims[1]*sizeof(double);
	write(fd[1],&message,sizeof(uint32_t));
	write(fd[1],&length,sizeof(uint32_t));
	write(fd[1],mxGetData(prhs[1]),length);
      }
      else if(strcmp(cmd,"lines")==0){
	int ndims;
	const int * dims;
	if(nrhs<2)mxErrMsgTxt("Need points as 3 x n matrix");
	ndims = mxGetNumberOfDimensions(prhs[1]);
	dims = mxGetDimensions(prhs[1]);
		
	message=APPEND_LINES;
	length=3*dims[1]*sizeof(double);
	write(fd[1],&message,sizeof(uint32_t));
	write(fd[1],&length,sizeof(uint32_t));
	write(fd[1],mxGetData(prhs[1]),length);
      }
      else if(strcmp(cmd,"clear")==0){
	message=CLEAR;
	length=0;
	write(fd[1],&message,sizeof(uint32_t));
	write(fd[1],&length,sizeof(uint32_t));
      }
      else if(strcmp(cmd,"record")==0){
	message=RECORD;
	length=0;
	write(fd[1],&message,sizeof(uint32_t));
	write(fd[1],&length,sizeof(uint32_t));
      }
      else if(strcmp(cmd,"record_clear")==0){
	message=RECORD_CLEAR;
	length=0;
	write(fd[1],&message,sizeof(uint32_t));
	write(fd[1],&length,sizeof(uint32_t));
      }
    }
    break;
  case mxDOUBLE_CLASS:
    {
      uint32_t message=BONE_PARAMS,length;
      int i=0;
      int total = 1;
      int ndims = mxGetNumberOfDimensions(prhs[0]);
      const int * dims = mxGetDimensions(prhs[0]);
      /* printf("ndims is %d: [",ndims); */
      for(;i<ndims;i++){
	/* printf("%d ",dims[i]); */
	total*=dims[i];
      }
      /*printf("];  total=%d\n",total);*/

      length=sizeof(double)*total;
      write(fd[1],&message,sizeof(uint32_t));
      write(fd[1],&length,sizeof(uint32_t));
      write(fd[1],mxGetData(prhs[0]),sizeof(double)*total);
      break;
    }
  default:
    mexErrMsgTxt("First argument must be string or double array.\n");
    break;
  }
  if(called==0)atexit(onexit);
  called++;
}
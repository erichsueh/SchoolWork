void memclean(int count, Imageholder * contain){
  int x;
  //fprintf(stdout,"wtf\n");
  for (x=0;x!=count;x++)
    {
      //fprintf(stdout,"%d\n",count);
      free(contain[x].xarray);
      free(contain[x].yarray);
      //fprintf(stdout,"hue\n");
    }
  free(contain);
  //fprintf(stdout,"done\n");
  return;
}


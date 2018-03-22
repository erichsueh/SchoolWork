
vector <double> vecPercentage;
double doublePercentage = 0;
double determine_average = 0;
double determine_highest = 0;

int i = 1;//counter for while loop (# of results)
while (doublePercentage >= 0 && doublePercentage <= 100) //valid inputs
  {
    cout << "Enter result \"" << i << "\" between 0 and 100 inclusively [or <0 or >100 to exit]: ";
    cin >> doublePercentage;//store student's percentage mark
    if (doublePercentage >= 0 && doublePercentage <= 100)
      {
	i++;//increment # of results by 1
	vecPercentage.push_back(doublePercentage);
	determine_grade(doublePercentage);
	cout << " will be assigned to this result.\n";
      }
  }
cout << "\nSummary of the results : ";
cout << "\n......working on it....." << endl << endl;
{
  
  //add code below to provide a summary, a loop is expected
  determine_average = average(vecPercentage);
  cout << "The average of the results = " << setprecision(2) << showpoint << fixed << determine_average << "\n";
  determine_highest = highest(vecPercentage);
  cout << "The highest of the results = " << setprecision(2) << showpoint << fixed << determine_highest << "\n";
  
}
return 0;
}
//function to determine letter grade
void determine_grade(double doublePercentage)
{
  if (doublePercentage > 80)//if percentage is bigger than 80
    cout << "Grade A";//print "Grade A"
  else if (doublePercentage > 70)
    cout << "Grade B";
  else if (doublePercentage > 60)
    cout << "Grade C";
  else
    cout << "Grade F";
}
//add definitions for other 3 functions below
double average (vector <double> vA)
{
  double intSum = 0;
  double average_num = 0;
  for (int i = 0; i < vA.size(); i++)
    {
      intSum += vA.at(i);
    }
  average_num = intSum /vA.size();
  return average_num;
}

double highest(vector <double> v)
{
  double high_num = v.at(0);
  for (int i = 0; i < v.size(); i++)
    {
      if (v.at(i) > high_num);
      {
	cout << "highbefore = " << high_num << "\n";
	cout << "vector = " << v.at(i) << "\n";
	high_num = v.at(i);
      }
      
      cout << "highafter = " << high_num << "\n";
    }
  return high_num;
}

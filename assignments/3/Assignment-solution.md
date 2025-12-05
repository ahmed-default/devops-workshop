# Linux Text Processing Assignment

## Task: Employee Data Analysis



***

## Step 1: Create the Data File

First, create a file called `employees.csv` with the following employee 

```bash
cat > employees.csv << 'EOF'
Ahmed,24,Developer,Cairo,45000
Fatma,29,Manager,Alexandria,65000
Omar,22,Intern,Giza,15000
Nour,31,Engineer,Cairo,55000
Youssef,27,Developer,Mansoura,48000
Mona,35,Manager,Cairo,70000
Karim,23,Designer,Alexandria,35000
Layla,28,Engineer,Giza,52000
Hassan,26,Developer,Cairo,46000
Aya,30,Analyst,Mansoura,41000
Mahmoud,33,Manager,Cairo,68000
Salma,25,Designer,Alexandria,38000
Khaled,29,Engineer,Giza,54000
Dina,24,Developer,Mansoura,44000
Amr,32,Analyst,Cairo,43000
EOF
```


### Task A: Basic Information Extraction 

      1- grep -i cairo employees.csv 

          awk -F ',' '$4 == "Cairo" ' employees.csv



      2- grep -c "Developer" employees.csv



      3- awk -F ',' '{print $1, $5}' employees.csv


### Task B: Data Sorting and Filtering 

      4- sort -t ',' -k5 -nr employees.csv > high_earners.txt



      5- awk -F ',' '$2 >= 25 && $2 <= 30 ' employees.csv


### Task C: Advanced Text Processing 


      8-  grep -ci cairo employees.csv   ----> 6
          grep -ci giza employees.csv   ----> 3
          grep -ci mansoura employees.csv   ----> 3
          grep -ci alexandria employees.csv   ----> 3



### Task D: Data Modification  

      10- sed 's/Developer/Software Engineer/' employees.csv > updated_employees.csv



      11- cat > employees_with_header.csv
          Name,Age,Position,City,Salary
          cat employees.csv >> employees_with_header.csv


### Task E: Reporting 

12. **Create a comprehensive report called `employee_report.txt` that includes:**

    - Total number of employees
    - Average age
    - Average salary
    - Number of employees per city
    - Highest and lowest salaries

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    - wc -l employees.csv   ----> 15 employees
    - Average age = 28
    - Average salary = 47000

    - grep -ci cairo employees.csv   ----> 6
      grep -ci giza employees.csv   ----> 3
      grep -ci mansoura employees.csv   ----> 3
      grep -ci alexandria employees.csv   ----> 3

    - Highest salary : 70000
      Lowest salary : 15000


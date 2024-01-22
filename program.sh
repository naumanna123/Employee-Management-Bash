#!/bin/bash

# Employee Management System

declare -a employees

load_data() {
    if [ -f "employee_data.csv" ]; then
        echo "Loading data from employee_data.csv..."
        while IFS=, read -r name designation department salary; do
            employees+=("$name,$designation,$department,$salary")
        done < "employee_data.csv"
        echo "Data loaded successfully."
    else
        echo "No previous data found."
    fi
}

save_data() {
    echo "Saving new data to employee_data.csv..."
    temp_file="temp_employee_data.csv"
    for employee in "${employees[@]}"; do
        echo "$employee" >> "$temp_file"
    done
    mv "$temp_file" "employee_data.csv"
    echo "New data saved successfully."
}

load_data

while true; do
    echo "1. Add Employee"
    echo "2. View Employees"
    echo "3. Search Employee"
    echo "4. Edit Employee Data"
    echo "5. Save and Exit"

    read -p "Enter your choice: " choice

    case $choice in
        1)
            read -p "Enter employee name: " name	
            read -p "Enter employee designation: " designation
            read -p "Enter employee department: " department
            read -p "Enter employee salary: " salary
            employees+=("$name,$designation,$department,$salary")
            echo "Employee added successfully."
            ;;
        2)
            if [ ${#employees[@]} -eq 0 ]; then
                echo "No employees found."
            else
                echo "Employee List:"
                for ((i=0; i<${#employees[@]}; i++)); do
                    echo "$(($i+1)). ${employees[$i]}"
                done
            fi
            ;;
        3)
            read -p "Enter employee name to search: " search_name
            found=false
            for employee in "${employees[@]}"; do
                IFS=',' read -r emp_name emp_designation emp_department emp_salary <<< "$employee"
                if [ "$emp_name" == "$search_name" ]; then
                    echo "Employee found:"
                    echo "Name: $emp_name"
                    echo "Designation: $emp_designation"
                    echo "Department: $emp_department"
                    echo "Salary: $emp_salary"
                    found=true
                    break
                fi
            done
            if [ "$found" == "false" ]; then
                echo "Employee not found."
            fi
            ;;
        4)
            read -p "Enter employee name to edit data: " edit_name
            found=false
            for ((i=0; i<${#employees[@]}; i++)); do
                IFS=',' read -r emp_name emp_designation emp_department emp_salary <<< "${employees[$i]}"
                if [ "$emp_name" == "$edit_name" ]; then
                    echo "Select attribute(s) to edit:"
                    echo "1. Designation"
                    echo "2. Department"
                    echo "3. Salary"
                    read -p "Enter choice(s) separated by commas: " edit_choices

                    IFS=',' read -ra choices_arr <<< "$edit_choices"
                    for choice in "${choices_arr[@]}"; do
                        case $choice in
                            1)
                                read -p "Enter new designation: " new_designation
                                employees[$i]="$emp_name,$new_designation,$emp_department,$emp_salary"
                                ;;
                            2)
                                read -p "Enter new department: " new_department
                                employees[$i]="$emp_name,$emp_designation,$new_department,$emp_salary"
                                ;;
                            3)
                                read -p "Enter new salary: " new_salary
                                employees[$i]="$emp_name,$emp_designation,$emp_department,$new_salary"
                                ;;
                            *)
                                echo "Invalid choice."
                                ;;
                        esac
                    done
                    echo "Employee data updated successfully."
                    found=true
                    break
                fi
            done
            if [ "$found" == "false" ]; then
                echo "Employee not found."
            fi
            ;;
        5)
            save_data
            echo "Exiting Employee Management System."
            exit 0
            ;;
        *)
            echo "Invalid choice. Please enter a valid option."
            ;;
    esac
done

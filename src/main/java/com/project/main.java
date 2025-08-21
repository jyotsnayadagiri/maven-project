package com.jyotsna.todo;

import java.util.Scanner;

public class Main {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        ToDoList toDoList = new ToDoList();
        
        while (true) {
            System.out.println("\n=== TO-DO LIST ===");
            System.out.println("1. Add task");
            System.out.println("2. View tasks");
            System.out.println("3. Mark task as done");
            System.out.println("4. Exit");
            System.out.print("Choose an option: ");
            
            int choice = scanner.nextInt();
            scanner.nextLine(); // consume newline
            
            switch (choice) {
                case 1:
                    System.out.print("Enter task: ");
                    String task = scanner.nextLine();
                    toDoList.addTask(task);
                    break;
                    
                case 2:
                    toDoList.viewTasks();
                    break;
                    
                case 3:
                    System.out.print("Enter task number to mark as done: ");
                    int taskNumber = scanner.nextInt();
                    toDoList.markTaskAsDone(taskNumber);
                    break;
                    
                case 4:
                    System.out.println("Goodbye!");
                    scanner.close();
                    return;
                    
                default:
                    System.out.println("Invalid option!");
            }
        }
    }
}

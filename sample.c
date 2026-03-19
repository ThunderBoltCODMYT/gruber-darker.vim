#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

/**
 * @brief Sample C program demonstrating gruber-darker theme syntax highlighting
 *
 * This program showcases various C language constructs to demonstrate
 * the color scheme's syntax highlighting capabilities.
 */

// Define constants
#define MAX_BUFFER_SIZE 1024
#define PI 3.141592653589793

// Global variables
static int global_counter = 0;
volatile bool system_ready = false;

// Structure definitions
typedef struct
{
    char name[50];
    int age;
    float salary;
    bool active;
} Employee;

typedef union
{
    int int_value;
    float float_value;
    char *string_value;
} DataUnion;

// Function prototypes
void initialize_system(void);
int process_data(const char *input, Employee *emp);
void display_results(Employee *employees, size_t count);
static void cleanup_resources(void);

// Error codes enumeration
typedef enum
{
    SUCCESS = 0,
    ERROR_INVALID_INPUT = -1,
    ERROR_MEMORY_ALLOCATION = -2,
    ERROR_FILE_OPERATION = -3
} ErrorCode;

/**
 * Main entry point
 */
int main(int argc, char *argv[])
{
    // Local variable declarations
    Employee *employees = NULL;
    size_t employee_count = 0;
    char buffer[MAX_BUFFER_SIZE];
    ErrorCode result;

    printf("Gruber-Darker Theme Demonstration Program\n");
    printf("==========================================\n\n");

    // Initialize the system
    initialize_system();

    // Process command line arguments
    if (argc > 1)
    {
        for (int i = 1; i < argc; i++)
        {
            printf("Processing argument %d: %s\n", i, argv[i]);

            // Allocate memory for new employee
            employees = realloc(employees, sizeof(Employee) * (employee_count + 1));
            if (employees == NULL)
            {
                fprintf(stderr, "Memory allocation failed!\n");
                return ERROR_MEMORY_ALLOCATION;
            }

            // Process the data
            result = process_data(argv[i], &employees[employee_count]);
            if (result == SUCCESS)
            {
                employee_count++;
            }
            else
            {
                fprintf(stderr, "Failed to process data: %s\n", argv[i]);
            }
        }
    }
    else
    {
        // Interactive mode
        printf("Enter employee data (name,age,salary,active):\n");
        printf("Type 'quit' to exit\n\n");

        while (fgets(buffer, sizeof(buffer), stdin) != NULL)
        {
            // Remove newline character
            buffer[strcspn(buffer, "\n")] = '\0';

            if (strcmp(buffer, "quit") == 0)
            {
                break;
            }

            // Allocate memory for new employee
            employees = realloc(employees, sizeof(Employee) * (employee_count + 1));
            if (employees == NULL)
            {
                fprintf(stderr, "Memory allocation failed!\n");
                result = ERROR_MEMORY_ALLOCATION;
                goto cleanup;
            }

            result = process_data(buffer, &employees[employee_count]);
            if (result == SUCCESS)
            {
                employee_count++;
                printf("Employee added successfully. Total: %zu\n", employee_count);
            }
            else
            {
                fprintf(stderr, "Invalid input format. Use: name,age,salary,active\n");
            }
        }
    }

    // Display results if we have employees
    if (employee_count > 0)
    {
        printf("\nEmployee Summary:\n");
        printf("=================\n");
        display_results(employees, employee_count);
    }

    // Control flow demonstration
    for (size_t i = 0; i < employee_count; i++)
    {
        if (employees[i].active)
        {
            printf("Active employee: %s\n", employees[i].name);
        }
    }

    // Switch statement example
    switch (result)
    {
    case SUCCESS:
        printf("Program completed successfully!\n");
        break;
    case ERROR_INVALID_INPUT:
        fprintf(stderr, "Invalid input provided\n");
        break;
    case ERROR_MEMORY_ALLOCATION:
        fprintf(stderr, "Memory allocation error\n");
        break;
    default:
        fprintf(stderr, "Unknown error occurred\n");
        break;
    }

cleanup:
    // Clean up resources
    cleanup_resources();
    free(employees);

    return result;
}

/**
 * Initialize system components
 */
void initialize_system(void)
{
    printf("Initializing system...\n");

    // Simulate initialization
    for (int i = 0; i < 3; i++)
    {
        printf("Component %d initialized\n", i + 1);
    }

    system_ready = true;
    global_counter = 42;

    printf("System ready!\n\n");
}

/**
 * Process input data and populate employee structure
 */
int process_data(const char *input, Employee *emp)
{
    char temp_buffer[MAX_BUFFER_SIZE];
    char *token;
    int field_count = 0;

    // Copy input to avoid modifying original
    strncpy(temp_buffer, input, sizeof(temp_buffer) - 1);
    temp_buffer[sizeof(temp_buffer) - 1] = '\0';

    // Parse CSV-like input: name,age,salary,active
    token = strtok(temp_buffer, ",");
    while (token != NULL && field_count < 4)
    {
        // Remove leading/trailing whitespace
        while (*token == ' ' || *token == '\t')
            token++;
        char *end = token + strlen(token) - 1;
        while (end > token && (*end == ' ' || *end == '\t'))
            end--;
        *(end + 1) = '\0';

        switch (field_count)
        {
        case 0: // Name
            if (strlen(token) >= sizeof(emp->name))
            {
                return ERROR_INVALID_INPUT;
            }
            strcpy(emp->name, token);
            break;
        case 1: // Age
            emp->age = atoi(token);
            if (emp->age < 0 || emp->age > 150)
            {
                return ERROR_INVALID_INPUT;
            }
            break;
        case 2: // Salary
            emp->salary = atof(token);
            if (emp->salary < 0)
            {
                return ERROR_INVALID_INPUT;
            }
            break;
        case 3: // Active status
            if (strcmp(token, "true") == 0 || strcmp(token, "1") == 0)
            {
                emp->active = true;
            }
            else if (strcmp(token, "false") == 0 || strcmp(token, "0") == 0)
            {
                emp->active = false;
            }
            else
            {
                return ERROR_INVALID_INPUT;
            }
            break;
        }

        field_count++;
        token = strtok(NULL, ",");
    }

    // Verify we got all required fields
    if (field_count != 4)
    {
        return ERROR_INVALID_INPUT;
    }

    return SUCCESS;
}

/**
 * Display employee information
 */
void display_results(Employee *employees, size_t count)
{
    printf("%-20s %-5s %-10s %-6s\n", "Name", "Age", "Salary", "Active");
    printf("%-20s %-5s %-10s %-6s\n", "----", "---", "------", "------");

    for (size_t i = 0; i < count; i++)
    {
        printf("%-20s %-5d $%-9.2f %-6s\n",
               employees[i].name,
               employees[i].age,
               employees[i].salary,
               employees[i].active ? "Yes" : "No");
    }

    printf("\nTotal employees: %zu\n", count);
}

/**
 * Clean up system resources
 */
static void cleanup_resources(void)
{
    printf("Cleaning up resources...\n");

    // Reset global state
    system_ready = false;
    global_counter = 0;

    printf("Cleanup complete.\n");
}

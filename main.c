//Write your code in this file
#include <stdio.h>
#include <ctype.h>
#include <string.h>

#define STUDENTS 5
#define TESTS 13

// Function that makes first into a capital and the rest non-capital
void fixName(char *name)
{
    if (name[0])
        name[0] = toupper(name[0]);
    for (int i = 1; name[i]; i++ )
    {
        name[i] = tolower(name[i]);
    }
}

int main()
{
    char names[STUDENTS][20];
    int scores[STUDENTS][TESTS];
    double averages[STUDENTS];

    // read in data
    for (int i = 0; i < STUDENTS; i++)
    {
        scanf("%s", names[i]);
        for (int j = 0; j < TESTS; j++)
        {
            scanf("%d", &scores[i][j]);
        }
    }

    // Calculate average score
    for (int i = 0; i < STUDENTS; i++)
    {
        int sum = 0;
        for (int j = 0; j < TESTS; j++)
        {
            sum += scores[i][j];
        }
        averages[i] = (double)sum / TESTS;
    }

    // Find the highest average
    int bestIndex = 0;
    for (int i = 0; i < STUDENTS; i++)
    {
        if (averages[i] > averages[bestIndex])
        {
            bestIndex = i;
        }
    }

    // calculate the group average
    double total = 0;
    for (int i = 0; i < STUDENTS; i++)
    {
        total += averages[i];
    }
    double groupAvg = total / STUDENTS;

    // Write out names with correct format
    // 1. Student with highest average
    fixName(names[bestIndex]);
    printf("%s\n", names[bestIndex]);

    // 2. students under groups average (same order as input)
    for (int i = 0; i < STUDENTS; i++)
    {
        if (averages[i] < groupAvg)
        {
            fixName(names[i]);
            printf("%s\n", names[i]);
        }
    }
    return 0;
}

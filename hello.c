/* Hello World program */
#include<stdio.h>
main()
{
    int b;
    printf("Enter an number:\n");
	scanf("%d", &b);
	if (b > 0)	{
			printf("Hello! %d is greater than 0", b);
	}
	else	{
			printf("Hello! %d is less than 0", b);
	}
	return 0;
}

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void printPuzzle(char** arr);
void searchPuzzle(char** arr, char* word);
int bSize;
int Char_Length(char* word);
void Capitalize_Whole_Word(char *word, int char_size);
int eight_directions(int char_size, char** arr, char* word, int l, int store_row, int store_column);
int ** Array_Zeros;

// Main function
int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <puzzle file name>\n", argv[0]);
        return 2;
    }
    int i, j;
    FILE *fptr;

    // Open file for reading puzzle
    fptr = fopen(argv[1], "r");
    if (fptr == NULL) {
        printf("Cannot Open Puzzle File!\n");
        return 0;
    }

    // Read the size of the puzzle block
    fscanf(fptr, "%d\n", &bSize);
    
    // Allocate space for the puzzle block and the word to be searched
    char **block = (char**)malloc(bSize * sizeof(char*));
    char *word = (char*)malloc(20 * sizeof(char));

    // Read puzzle block into 2D arrays
    for(i = 0; i < bSize; i++) {
        *(block + i) = (char*)malloc(bSize * sizeof(char));
        for (j = 0; j < bSize - 1; ++j) {
            fscanf(fptr, "%c ", *(block + i) + j);
        }
        fscanf(fptr, "%c \n", *(block + i) + j);
    }
    fclose(fptr);

    printf("Enter the word to search: ");
    scanf("%s", word);
    
    // Print out original puzzle grid
    printf("\nPrinting puzzle before search:\n");
    printPuzzle(block);
    
    // Call searchPuzzle to the word in the puzzle
    searchPuzzle(block, word);
    
    return 0;
}

void printPuzzle(char** arr) {
    int n = bSize;
    char i = 0;
    char j = 0;
    while (i != n){
            while (j != n){
                printf("%c ", *(*(arr+i) + j));
                j++;
            }
        printf("\n");
        j = 0;
        i++;
    }
    printf("\n");
}

//6197050420

int eight_directions(int char_size, char** arr, char* word, int l, int store_row, int store_column){
    
    if (l == char_size - 1){ //saying if the size is met
        return 1;
    }
    
    l++;
 //this is for incrementing the element of the words
    
    for(int i = store_row - 1; i < store_row + 2; i++){ //only checking the rows of element at hand
        //Example, if element is at Row = 1, then we focus on Row 0 up to Row 2 (since it meets it by boundaries)
        for (int j = store_column - 1; j < store_column + 2; j++){  (previous explanation)
            if(!(i == store_row && j == store_column)){
                if(i > -1){
                    if(i < bSize){
                        if (j > -1){
                            if(j < bSize){
                                if(*(*(arr + i) + j) == *(word + l)){/
                                    if(eight_directions(char_size, arr, word, l, i, j) == 1){
                                        if(*(*(Array_Zeros + i) + j) > 0){
                                            *(*(Array_Zeros + i) + j) = *(*(Array_Zeros + i) + j)*10 + (l + 1);
                                        }else{
                                            *(*(Array_Zeros + i) + j) = l + 1; 
                                        }
                                        return 1;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    return 0;
}

int Char_Length(char* word){ // finding out size of word
    int char_size = 0;
    while(*word){
        char_size = char_size + 1;
        word = word + 1;
    }
    return char_size;
}

void Capitalize_Whole_Word(char* word, int char_size){ //Function To capitalize the char* (word)
    //Using Ascii method.
    for (int i = 0; i < char_size; i++){
        if(*(word + i) >= 'a' && *(word + i) <= 'z'){
            *(word + i) = *(word + i) - 32;
        }
    }
}

void searchPuzzle(char** arr, char* word) {
    int n = bSize;
    int i = 0;
    int j = 0;
    int l = 0; //Element of the words
    //I.e. Hello
    //If L == 0, then H is being looked at.
    //If L == 2, then L is being looked at. etc.
    int char_size = Char_Length(word); //using char_length function to find char_size
    int word_success = 0;
    
//Making Array oF Zeros by allocating a new 2-D array
    Array_Zeros = (int**)malloc(bSize * sizeof(int*));
    for(int i = 0; i < bSize; i++) {
        *(Array_Zeros + i) = (int*)malloc(bSize * sizeof(int));
        for (int j = 0; j < bSize; j++) {
            *(*(Array_Zeros + i) + j) = 0;
             }
    }
    Capitalize_Whole_Word(word, char_size); //calling function,, word being modified by char_size
    
    while (i != n){
           while (j != n){
               if (*(*(arr+i) + j) != *(word + l)){
                   j++;
                }else{
                    if(eight_directions(char_size,arr,word,l,i,j) == 1){
                        if(*(*(Array_Zeros + i) + j) > 0){
                            *(*(Array_Zeros + i) + j) = *(*(Array_Zeros + i) + j)*10 + (l + 1);
                        }else{
                        *(*(Array_Zeros + i) + j) = 1;
                        }// we need to put this so we can print a "1" for the first element.
                            //The function eight_directions doesnt print "1", because it increments l within it's own scope, so it will never see the first element.
                        word_success = 1;
                    }
                    j++; // we increment j to look through the rest of the columns
                   }
               }
           i++; //Incrementing I to increase the row
           j = 0; //Resetting J so when we start new row, we start looking at the first column
           }
    printf("\n");
    if (word_success == 1){
        printf("Word found!\n");
        printf("Printing the search path:\n");
            for(int x = 0; x < bSize; x++){
                for(int y = 0; y < bSize; y++){
                    printf("%d\t", *(*(Array_Zeros + x) + y));
                }
                printf("\n");
            }
    }
    if (word_success == 0){
        printf("Word not found!\n");
    }
    return;
}

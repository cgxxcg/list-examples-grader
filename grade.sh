#originally: CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'
#change to ../ because we cd grading-area before compilation
CPATH='.:../lib/hamcrest-core-1.3.jar:../lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'


#my code starts here 
if [[ -e "student-submission/ListExamples.java" ]]
then 
    echo "file exits!"
else 
echo "file doesn't exit!"
fi
#cp -r folderoriginal foldercopy: copy directories and their contents
#now I want to copy ListExamples.java and TestListExamples.java into grading-are directory
cp -r ~/list-examples-grader/student-submission/ListExamples.java grading-area
cp -r ~/list-examples-grader/TestListExamples.java grading-area

cd grading-area

#注意这里不是cp,而是 -cp = classpath
#imagine -cp和后面一坨是连着的，告诉javac where to find classes and resources during compilation 
javac -cp $CPATH *.java 2> compile-error.txt
if grep -q "error" compile-error.txt
then 
    echo "Failed to compile"
    cat compile-error.txt
    exit 1
else

if [[ $? -eq 0 ]]
then 
    java -cp $CPATH org.junit.runner.JUnitCore TestListExamples > result.txt
    echo "passed"
    echo "Your test result:"
grep 'Tests run:' result.txt
total=$(grep -o "run: [0-9]*" result.txt | grep -o "[0-9]*")    
if grep -q "OK" "result.txt"
then 
    echo "Grade: 100"
    exit 0
fi
echo "this is total:"
echo $total
fail=$(grep -o "Failures: [0-9]*" result.txt | grep -o "[0-9]*")
echo "Your score:"
Score=$(($total-$fail))
echo $Score
fi
fi

# Draw a picture/take notes on the directory structure that's set up after
# getting to this point


# Then, add here code to compile and run, and do any post-processing of the
# tests

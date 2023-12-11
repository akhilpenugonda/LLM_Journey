'In Java, you can achieve the functionality of the given COBOL code by creating separate classes for each program and using method calls to connect them. Here\'s an example of how you can implement it:\n\n```java\n// Controller.java\npublic class Controller {\n    public static void main(String[] args) {\n        View view = new View();\n        Model model = new Model();\n\n        view.acceptUserInput();\n        String userInput = view.getUserInput();\n\n        int calculatedData = model.calculateData(userInput);\n\n        view.displayData(userInput, calculatedData);\n    }\n}\n\n// View.java\nimport java.util.Scanner;\n\npublic class View {\n    private String userInput;\n\n    public void acceptUserInput() {\n        Scanner scanner = new Scanner(System.in);\n        System.out.print("Enter a number: ");\n        userInput = scanner.nextLine();\n    }\n\n    public String getUserInput() {\n        return userInput;\n    }\n\n    public void displayData(String userInput, int calculatedData) {\n        String displayData = "Input: " + userInput + " Calculated: " + calculatedData;\n        System.out.println(displayData);\n    }\n}\n\n// Model.java\npublic class Model {\n    public int calculateData(String input) {\n        int inputData = Integer.parseInt(input);\n        int calculatedData = inputData + 10;\n        return calculatedData;\n    }\n}\n```\n\nTo run this code, you need to have the Java Development Kit (JDK) installed on your machine. You can compile and run the code using the following commands in the command line:\n\n```\njavac Controller.java\njava Controller\n```\n\nThis will compile and run the Controller class, which will execute the complete program and provide the desired output.'
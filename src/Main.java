import java.io.*;
import java.nio.charset.StandardCharsets;

public class Main {
    public static void main(String[] args) throws IOException {
        // System.out.println("Path: " + args[0]);

        // Open try.txt and read its bytes, decode them as UTF-8 into characters, and keep that connection in Reader in
        Reader in = new InputStreamReader(new FileInputStream(args[0]), StandardCharsets.UTF_8);

        ArithScanner scanner = new ArithScanner(in);
        
        // Header
        System.out.println(ArithScanner.header());

        // loop runs until the scanner reaches the end of the file
        String row;
        while ((row = scanner.yylex()) != null) {
            // prints each row
            System.out.println(row);
        }

    }
}

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class MostFrequentWords {
    public static List<String> getMostFrequentWords(String string, Integer numberOfWords) {
        if (numberOfWords < 1 || string.equals("")) {
            return new ArrayList<>();
        }

        HashMap<String, Integer> wordsNumber = new HashMap<>();
        for (String word : string.split(" ")) {
            wordsNumber.put(word, wordsNumber.getOrDefault(word, 0) + 1);
        }

        List<String> mostFrequentWords = wordsNumber
                .entrySet().stream()
                .sorted(Map.Entry.<String, Integer>comparingByValue().reversed())
                .limit(numberOfWords)
                .map(Map.Entry::getKey)
                .collect(Collectors.toList());

        for (String word : mostFrequentWords) {
            System.out.println(word);
        }

        return mostFrequentWords;
    }
}

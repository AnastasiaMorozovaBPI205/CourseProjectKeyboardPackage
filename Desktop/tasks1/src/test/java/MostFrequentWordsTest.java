import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

class MostFrequentWordsTest {
    @Test
    void getOneWord() {
        assertEquals(List.of("cat"), MostFrequentWords.getMostFrequentWords("cat bought a cat in a cat store", 1));
    }

    @Test
    void getThreeWord() {
        assertEquals(List.of("a", "cat"), MostFrequentWords.getMostFrequentWords("cat bought a cat in a cat store and dog bought a dog", 2));
    }

    @Test
    void emptyString() {
        assertEquals(List.of(), MostFrequentWords.getMostFrequentWords("", 2));
    }

    @Test
    void tooSmallNumberOfWords() {
        assertEquals(List.of(), MostFrequentWords.getMostFrequentWords("cat cat cat", 0));
    }

    @Test
    void numberOfWordsToGetGreaterThanActualNumberOfWords() {
        assertEquals(List.of("cat"), MostFrequentWords.getMostFrequentWords("cat cat cat", 5));
    }
}
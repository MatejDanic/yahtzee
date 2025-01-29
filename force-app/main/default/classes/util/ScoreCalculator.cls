public with sharing class ScoreCalculator {
    
    public static Integer calculateScore(List<Dice> diceCup, Category cat) {
        switch on cat {
            when ONES, TWOS, THREES, FOURS, FIVES, SIXES {
                return calculateSum(diceCup, cat);
            }
            when THREE_OF_A_KIND {
                return calculateThreeOfAKind(diceCup);
            }
            when FOUR_OF_A_KIND {
                return calculateFourOfAKind(diceCup);
            }
            when FULL_HOUSE {
                return calculateFullHouse(diceCup);
            }
            when SMALL_STRAIGHT {
                return calculateSmallStraight(diceCup);
            }
            when LARGE_STRAIGHT {
                return calculateLargeStraight(diceCup);
            }
            when YAHTZEE {
                return calculateYahtzee(diceCup);
            }
            when CHANCE {
                return calculateSum(diceCup);
            }
            when else {
                return 0;
            }
        }
    }

    private static Integer calculateSum(List<Dice> diceCup) {
        Integer sum = 0;
        for (Dice dice : diceCup) {
            sum += dice.value;
        }
        return sum;
    }

    private static Integer calculateSum(List<Dice> diceCup, Category cat) {
        Integer sum = 0;
        for (Dice dice : diceCup) {
            if (dice.value == (cat.ordinal() + 1)) {
                sum += dice.value;
            }
        }
        return sum;
    }

    private static Integer calculateThreeOfAKind(List<Dice> diceCup) {
        if (calculateMaxRepeatingCount(diceCup) >= 3) {
            return calculateSum(diceCup);
        }
        return 0;
    }



    private static Integer calculateFourOfAKind(List<Dice> diceCup) {
        if (calculateMaxRepeatingCount(diceCup) >= 4) {
            return calculateSum(diceCup);
        }
        return 0;
    }

    private static Integer calculateFullHouse(List<Dice> diceCup) {
        if (calculateMaxRepeatingCount(diceCup) == 3 && calculateDistinctCount(diceCup) == 2) {
            return 25;
        }
        return 0;
    }

    private static Integer calculateMaxRepeatingCount(List<Dice> diceCup) {
        Map<Integer, Integer> valueCounts = new Map<Integer, Integer>();
        for (Dice dice : diceCup) {
            Integer valueCount = 0;
            if (valueCounts.containsKey(dice.value)) {
                valueCount = valueCounts.get(dice.value);
            }
            valueCount += 1;
            valueCounts.put(dice.value, valueCount);
        }

        Integer maxValueCount = 0;
        for (Integer diceValue : valueCounts.keySet()) {
            if (valueCounts.get(diceValue) >= maxValueCount) {
                maxValueCount = valueCounts.get(diceValue);
            }
        }

        return maxValueCount;
    }

    private static Integer calculateSmallStraight(List<Dice> diceCup) {
        if (calculateDistinctCount(diceCup) == 5) {
            return Constants.SMALL_STRAIGHT;
        }
        return 0;
    }

    private static Integer calculateLargeStraight(List<Dice> diceCup) {
        if (calculateDistinctCount(diceCup) == 5) {
            return Constants.LARGE_STRAIGHT;
        }
        return 0;
    }

    private static Integer calculateDistinctCount(List<Dice> diceCup) {
        Set<Integer> uniqueValues = new Set<Integer>();
        for (Dice dice : diceCup) {
            uniqueValues.add(dice.value);
        }
        return uniqueValues.size();
    }

    private static Integer calculateYahtzee(List<Dice> diceCup) {
        if (calculateMaxRepeatingCount(diceCup) == 5) {
            return 50;
        }
        return 0;
    }

}
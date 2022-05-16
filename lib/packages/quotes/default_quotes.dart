import 'dart:math';

T getRandomElement<T>(List<T> list) {
  final random = Random();
  var i = random.nextInt(list.length);
  return list[i];
}

const list_default_quotes = [
  "Don't cry because it's over, smile because it happened",
  "You've gotta dance like there's nobody watching, love like you'll never be hurt, sing like there's nobody listening, and live like it's heaven on earth",
  "You only live once, but if you do it right, once is enough",
  "To live is the rarest thing in the world. Most people exist, that is all",
  "Insanity is doing the same thing, over and over again, but expecting different results. ― Narcotics Anonymous",
  "There are only two ways to live your life. One is as though nothing is a miracle. The other is as though everything is a miracle",
  "Good friends, good books, and a sleepy conscience: this is the ideal life",
  "Everything you can imagine is real",
  "Sometimes the questions are complicated and the answers are simple",
  "Sometimes people are beautiful. Not in looks. Not in what they say. Just in what they are",
  "Life is like riding a bicycle. To keep your balance, you must keep moving",
  "When someone loves you, the way they talk about you is different. You feel safe and comfortable",
  "But better to get hurt by the truth than comforted with a lie",
  "We are all in the gutter, but some of us are looking at the stars",
];

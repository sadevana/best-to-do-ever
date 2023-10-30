//
//  СompanionPhrases.swift
//  Eris
//
//  Created by Dmitry Chicherin on 24/10/2566 BE.
//

import Foundation

enum situations: String {
    case questCreated = "questCreated"
    case questUpdated = "questUpdated"
    case questCompleted = "questCompleted"
    case questUndone = "questUndone"
    case questDeleted = "questDeleted"
    case picked = "picked"
}

let lunaPhrases = [
    situations.questCreated.rawValue: ["Quest Accepted!", "Horray, new quest!", "Wrote it down for you"],
    situations.questUpdated.rawValue: ["Saved your changes!", "I'll remember that"],
    situations.questCompleted.rawValue: ["Yay, you did it!", "Great job on that one!", "You are doing great!", "Oof, don't have to worry about this one anymore", "Yay, go you!"],
    situations.questUndone.rawValue: ["Got it back for you!", "Back to undone!"],
    situations.questDeleted.rawValue: ["Got rid of it!", "Almost as good as completing it!"],
    situations.picked.rawValue: ["Yay, let's go!", "Adventure awaits!", "It's my favorite to be your companion!"]
]

let lunaChatter = [
    "What is your favorite food?" : "I kinda like steaks, he-he",
    "What do you like doing in your free time?" : "I like swimming! And eating!",
    "What is your favorite season?" : "I like summer the most! It's when I feel most energetic",
    "What do you think about deadlines?" : "Deadlines are awful! They always somehow make me do things at the last moment",
    "How do you always stay so energetic?": "I always have a positive outlook on things! Being optimistic is a great power",
    "What kind of quests do you like?": "I like things that involve going somewhere, especially new places!",
    "Do you have a dream?": "I want to win an eating contest         ....And to help you become the best version of yourself!",
    "What do you think I should do today?": "I think you should just live your life to the fullest, just like any other day",
    "Do you have any family?": "I have a big family and 6 siblings! Sometimes it gets too loud at home, even for me",
    "How old are you?": "That's a secret!",
    "Do you like cats or dogs more?": "I'm a dog person! Dogs are much more fun to play with",
    "When is your birthday?": "It's on July 2nd!",
    "What's your favorite type of music?": "I love upbeat tunes! They always get me in the adventure mood",
    "What's the best advice you've ever received?" : "Someone once told me, 'Always be curious and never stop exploring!' I've lived by that ever since",
    "Do you have a favorite book?" : "I don't read as much as I should, but I love tales of grand adventures and hidden treasures!",
    "Where would you like to travel?" : "Everywhere! There are so many places to explore and mysteries to uncover",
    "What's your favorite color?" : "Can you guess? It's green, just like my hair!",
    "Do you like the night or day more?" : "I love the daytime because it's perfect for adventures. But the night sky is so beautiful too!",
    "How do you handle fear?" : "By facing it head-on! Every challenge is an opportunity, after all",
    "What makes you laugh?" : "Silly jokes, unexpected surprises, and seeing someone smile",
    "Do you have a favorite game?" : "I enjoy treasure hunts and puzzles! They keep my mind sharp",
    "What inspires you?" : "Seeing people push their limits and achieve their dreams. It's so motivating!",
    "How do you relax after a long day?" : "Listening to the sounds of nature and daydreaming about the next big adventure",
    "Do you have a motto you live by?" : "Adventure awaits around every corner!"
]
let claraPhrases = [
    situations.questCreated.rawValue: ["Quest accepted", "I believe that you've got this", "Wrote it down for you"],
    situations.questUpdated.rawValue: ["Saved your changes", "Updated. It's important to keep everything tidy!"],
    situations.questCompleted.rawValue: ["Nicely done!", "I admire your diligence", "You are doing great!", "Well done", "Hey, that's great work"],
    situations.questUndone.rawValue: ["Returned it to undone quests!", "Undone it for you!"],
    situations.questDeleted.rawValue: ["Got rid of it!", "Almost as good as completing it!"],
    situations.picked.rawValue: ["I'm glad to be of assistance!", "Hey, I'm looking forward to whatever awaits us!"]
]
let claraChatter = [
    "What is your favorite food?" : "I enjoy desserts, especially Mont Blanc",
    "What do you like doing in your free time?" : "I enjoy reading and taking care of my pets",
    "What is your favorite season?" : "I really enjoy spring. I feel so refreshed when nature starts waking up",
    "Do you have any productivity tips?" : "When I'm feeling down, I just do things by putting in minimal effort. It helps me stay consistent!",
    "What kind of books do you like?" : "I prefer fantasy and non-fiction books",
    "What kind of quests do you like?" : "I enjoy quests that are slower-paced and relaxed, even if others might find them boring",
    "Do you have a dream?" : "I hope to write my own book someday",
    "Do you have any pets?" : "I have two cats and a pet turtle",
    "When is your birthday?" : "It's on February 12th",
    "Tell me a random fact" : "Sea otters are the only marine animals capable of lifting and turning over rocks",
    "Tell me a random fact " : "Though nothing can escape black holes, we believe they still slowly evaporate",
    "Tell me a random fact  " : "The English language used to have grammatical gender long ago",
    "Tell me a random fact   " : "The cocktail name 'Blue Hawaii' is tied to the film of the same name",
    "Do you prefer tea or coffee?" : "I prefer tea with milk! I can't sleep if I drink coffee.",
    "What's your favorite time of day?" : "I love the early morning, just before sunrise. The world feels so calm and peaceful",
    "What's a hobby you'd like to try?" : "I've always been curious about pottery. Shaping clay seems so therapeutic",
    "How do you relax after a long day?" : "I enjoy listening to soft music while sipping on chamomile tea",
    "What's your favorite type of weather?" : "A light drizzle with an overcast sky. Perfect for reading indoors",
    "What inspires you?" : "Nature, literature, and the kindness of strangers I encounter",
    "Which place would you love to visit?" : "I've always dreamt of seeing the cherry blossoms",
    "Do you like indoor or outdoor activities more?" : "I lean more towards indoor activities, like reading or painting",
    "What's your favorite flower?" : "I love lilies, especially the white ones. They're so elegant and fragrant",
    "How do you handle stress?" : "Taking deep breaths, meditating, and sometimes just taking a step back to re-evaluate",
    "What's a book you've read recently?" : "I just finished 'The Night Circus'. It's enchanting and beautifully written",
    "Do you enjoy puzzles or riddles?" : "Yes, especially the ones that make me think for days",
    "What's your favorite scent?" : "I love the scent of fresh linen and lavender. They're so calming",
    "How do you feel about technology?" : "It has its pros and cons. I appreciate the convenience, but sometimes, I miss the simplicity of the past"
]
let aikoPhrases = [
    situations.questCreated.rawValue: ["Hey, that means another journey with my $pronouns$!", "Added a quest for you ❤️", "Added it!"],
    situations.questUpdated.rawValue: ["I remember all of the changes you make, $pronouns$ ❤️", "Updated your quest!"],
    situations.questCompleted.rawValue: ["Well done! So proud of you", "Congratulations, $pronouns$ ❤️", "You are doing great!",  "You are doing such a good job, $pronouns$"],
    situations.questUndone.rawValue: ["Back to work on this one", "Undone it for you, $pronouns$!"],
    situations.questDeleted.rawValue: ["Got rid of it!", "This will never bother you again, $pronouns$"],
    situations.picked.rawValue: ["Heyyyyy, $pronouns$! ❤️", "Hey, I'm so glad you picked me!"]
]
let aikoChatter = [
    "What is your favorite food?" : "I like whatever we get to eat together $pronouns$! And chocolate.",
    "What do you like doing in your free time?" : "I like cooking and cheering you up, $pronouns$!",
    "Do you have any productivity tips?" : "Nope",
    "What kind of quests do you like?" : "I kind of like chores! It's predictable and nice!",
    "Do you have a dream?" : "Don't tell anyone but I sometimes dream of becoming an idol.",
    "Do you have any pets?" : "I have a dog named Sharpie, $pronouns$",
    "When is your birthday?" : "It's on February 14th, what, are you planning a surprise for me?",
    "What was your favorite subject in school?" : "I was really interested in chemistry",
    "If you could travel anywhere, where would you go?" : "I'm actually a stay-at-home type! But with the right companions, I'm ready to go anywhere."
]

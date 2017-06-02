import random
from app import app
from flask import request, Response

jokes = [
    'A rabbi, a priest, and a Lutheran minister walk into a bar. The bartender looks up and says, "Is this some kind of joke?"',
    'A screwdriver walks into a bar. The bartender says, "Hey, we have a drink named after you!" The Screwdriver responds, "You have a drink named Murray?"',
    'Guy walks into a bar and sits at a table. Tells the waitress, "I\'ll have a Bloody Mary and a menu." When she returns with his drink, he asks "Still servin\' breakfast?" When she says Yes, he replies, "Then I\'ll have two eggs-runny on top and burnt on the bottom, five strips of bacon ON END-well done on one end and still raw on the other, two pieces of burnt toast and a cold cup of coffee." Indignantly the waitress says, "We don\'t serve that kinda stuff in here!" Guy says, "Funny... that\'s what I had in here yesterday..."',
    'A panda walks into a bar and orders a beer and a hamburger. After he eats he stands up stretches and pulls out a gun shooting everyone in the room but the bartender. The panda puts $20 on the bar and turns to leave. As he walks out the door the bartender asks why the panda shot everyone. The panda tells him to look in the encyclopedia. The bartender looks up panda and he reads "Panda: Large black and white mammal native to China. Eats shoots and leaves."!',
    'A guy walks into a bar and asks for ten shots of the establishments finest single malt scotch. The bartender sets him up, and the guy takes the first shot in the row and pours it on the floor. He then takes the last one in the and does the same. The bartender asks him, "Why did you do that?" And the guy replies, " Well the first shot always tastes like crap, and the last one always makes me sick!"',
    'A priest, a rabbi, and a pastor are sitting in a bar, across the street from a brothel. They are sipping their drinks when they see a rabbi walk in to the brothel. "Oy! It\'s awful to see a man of the cloth give into temptation", says the rabbi. A short while later, they see a pastor walk into the brothel. "Damn! It\'s terrible to see a man of the cloth give into such temptation", says the pastor. In a little bit, they see a priest enter the brothel. "It\'s nice to see the ladies, who have been used so poorly, have time to confess their sins", says the priest.',
    'A guy walks into a bar. He asks the bartender, "Do you have any helicopter flavored potato chips?" The bartender shakes his head and says, "No, we only have plain."',
    'Horse walks into a bar. Bartender says, "So. Why the long face?"',
    'Skunk walks into a bar and he says, "Hey where did everybody go?"',
    'A guy walks in.........ok, he did not walk in, he was already there. One guy says, "I slept with my wife before we were married, did you?". The other guy says, "I don\'t know; what was her maiden name?".',
    ' E-flat walks into a bar, The bartender says, sorry, we don\'t serve minors......',
    'A potato walks into a bar and all eyes were on him!',
    'Two guys are sitting at a bar. One guy says to the other, "Do you know that lions have sex 10 or 15 times a night?". The other guy says, "Damn, I just joined the Rotary Club."',
    'A termite walks into a bar and says is the bartender here?',
    'A hamburger and a french fry walk into a bar. The bartender says, "I\'m sorry we don\'t serve food here',
    'So, Thomas Edison walks into a bar and orders a beer. The bartender says, "Okay, I\'ll serve you a beer, just don\'t get any ideas."',
    'So.... a baby seal walked into a club...',
    'A guy walks into a bar and sees a horse tending bar, apron and all, wiping out a glass. He stares at the horse '
    'for a minute without saying a word. The horse returns the stare and breaks the silence by asking, "Hey buddy, '
    'what\'s the matter? You can\'t believe that a horse can tend bar?" "No", the guys says, "I can\'t believe that '
    'the ferret sold the place."',
    'It\'s the Christmas season and a guy walks into a bar in Atlanta, GA and notices a Nativity Scene behind the bar. the Tree Wise Men are all wearing fireman\'s hats. He asks the bartender why the Magi are wearing fireman\'s hats and the barkeep says, "Well, everyone knows that they came from afar."',
    'An amnesiac walks into a bar. The bartender asks, "What can I get you today?" The amnesiac says, "I don\'t know,'
    ' I have trouble remembering things." The bartender says, "Like what?"',
    'Two peanuts walk into a bar. One was a salted.',
    'A jumper cable walks into a bar. The barman says "I\'ll serve you, but don\'t start anything."',
    'A man walks into a bar with a slab of asphalt under his arm and says:  "A beer please, and one for the road."',
    'Two hydrogen atoms walk into a bar. One says, "I\'ve lost my electron." The other says, "Are you sure?" The first replies, "Yes, I\'m positive..."',
    'A drunk walks into a bar. "Ouch!" he says.',
    'A skeleton walks into a bar and says “Give me a beer and a mop.”',
]

@app.route('/humor', methods=['POST'])
def inbound():
    if request.form.get('token') == 'lZbzdW6GJvfhXbkHhdn9L4GT':
        channel = request.form.get('channel_name')
        username = request.form.get('user_name')
        text = request.form.get('text')
        inbound_message = username + " in " + channel + " says: " + text
        print(inbound_message)
    return Response(random.choice(jokes)), 200

import "Logic.js" as GameLogic
import QtQml 2.0 //Also uses Timer
Story {
    id: testStory
    currentNode: menu
    property bool stylishMenu: false
    property int swearJar: 0
    allNodes: [
        TreeNode {
            id: menu
            choices: [
                Choice {
                    playerText: "New Game"
                    responseText: "" //Null, putting it in the other pass-through node
                    nextNode: swearJar <= 0 ? gameStart : gameNoStart
                }
                ,
                Choice {
                    playerText: "Save Game"
                    responseText: "Consider it done!"
                    nextNode: menu
                }
                ,
                Choice {
                    playerText: "Load Game"
                    responseText: "Which game would you like to load?"
                    nextNode: loadNode //TODO: Load screen (but out of scope for test content)
                }
                ,
                Choice {
                    id: exitChoice
                    playerText: "Exit Game"
                    responseText: testStory.swearJar > 0 ? "Bye" : "Good bye. I love you!"
                    onSelected: {
                        quitTimer.start();
                    }
                    property Timer quitTimer: Timer { interval: 1000; onTriggered: Qt.quit(); }
                    nextNode: menu //Just to keep it from "jumping"
                }
                ,
                Choice {
                    playerText: "Quick Game"
                    responseText: "I'm not implemented yet" //TODO: But needs other engine
                    nextNode: menu
                }
                ,
                Choice {
                    id: gameOptions
                    enabled: !testStory.stylishMenu
                    playerText: "Game Options"
                    responseText: "I'm not implemented yet"
                    nextNode: menu
                }
                ,
                Choice {
                    id: gameSorry
                    enabled: testStory.stylishMenu
                    playerText: "Sorry, Game"
                    responseText: "Ask nicely and I'll give you the options back"
                    nextNode: optionsAsk
                    onSelected: askingNicely.playerText = askingNicely.basicPlayerText //possible reset
                }
                ,
                Choice {
                    id: gameInsult
                    enabled: !testStory.stylishMenu
                    playerText: "Why not call it 'Options Game' and maintain the pattern? Why even have a separate options screen at all? You're already ruining the immersion and thus the entire game!"
                    responseText: "Since you asked so nicely, you can have the stylish menu."
                    onSelected: stylishMenu = true;
                    nextNode: menu
                }
            ]
        }, TreeNode {
            id: loadNode
            choices: [
                Choice {
                    playerText: "FakeGameAlpha"
                    responseText: "Loading FakeGameAlpha"
                    nextNode: gameStart
                },
                Choice {
                    playerText: "FakeGameBeta"
                    responseText: "Loading FakeGameBeta"
                    nextNode: gameStart
                },
                Choice {
                    playerText: "FakeGameGamma"
                    responseText: "Loading FakeGameGamma"
                    nextNode: gameStart
                }
            ]
        }, TreeNode {
            id: optionsAsk
            choices: [
                Choice {
                    id: askingNicely
                    property string basicPlayerText: "May I please have the full menu?"
                    playerText: basicPlayerText
                    responseText: "Of course"
                    onSelected: testStory.stylishMenu = false;
                    nextNode: menu
                },
                Choice {
                    playerText: "Fuck you, I need those options!"
                    responseText: ""
                    onSelected: testStory.swearJar += 1
                    nextNode: menu
                },
                Choice {
                    playerText: "Fuck you! I don't need your stinkin' options!"
                    responseText: "Of course"
                    onSelected: testStory.swearJar += 1
                    nextNode: menu
                },
                Choice {
                    playerText: "It only seems fair to allow access to the options functionality, you big tease."
                    responseText: "It only seems fair that you apologize after insulting the game menu..."
                    nextNode: optionsAsk 
                    onSelected: askingNicely.playerText = "I'm sorry I insulted your menu. May I please have the full menu back?"
                }
            ]
        }, TreeNode {
            id: gameNoStart
            prechoiceText: "You're a potty mouth. I don't want to play with you anymore."
            choices: [
                Choice {
                    playerText: "<Click to Continue>"
                    nextNode: menu
                    responseText: "" //Null
                }
            ]
        }, TreeNode {
        }, TreeNode {
            id: gameStart
            prechoiceText: "Once upon a time..."
            choices: [
                Choice {
                    playerText: "<Click to Continue>"
                    nextNode: n1A
                    responseText: "" //Null
                }
            ]
        }, TreeNode {
            id: n1A 
            prechoiceText: "W) Come on Gordon, we'll be late for the tea party!\nG) Well my legs are tiny, so you'll just have to wait!"
            choices: [
                Choice {
                    playerText: "Aw, look at the cute litte girl playing with her cute little doll"
                }
                ,
                Choice {
                    playerText: "Dolls are for girls! Er, little girls. Littler girls?"
                }
                ,
                Choice {
                    playerText: "Where's your tea party going to be Wendy?"
                }
                ,
                Choice {
                    playerText: "Aw, look at the cute litte girl playing with her cute little doll"
                }
                ,
                Choice {
                    playerText: "Buck up Gordon, the lady said speed up so DOUBLE TIME IT!"
                }
            ]
        }
    ]
}

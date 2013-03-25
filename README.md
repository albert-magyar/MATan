MATan: E177 Project Continued
=============================

Description
-----------
	
This project aims to emulate the board game “The Settlers of Catan” by Mayfair games. It allows 2-4 players to play in shared multi-player; the computer is handed off during a transition screen that appears between turns. The goal of the game is to build settlements on the game board that entitle the player to collect resources (cards) from surrounding areas.

Operations that involve selections of positions on the board are accomplished through clicking locations on the screen made active through GUI buttons. The entire board and all other information available to the player are shown on the interactive board. After a brief setup phase of the board, each player is free to perform one of several actions after rolling the dice to begin their turn. Their turn is concluded at the player's request, and control is briefly passed to a pop-up window designed to hide private information from the next player. This window is closed by the next user to begin their turn.

Structure
---------

The classes that exist in the game are: CatanGame, CatanBoard, CatanHex, Player, Card, ProgCard (progress card), Robber, Structure, Settlement, City, and Road. The CatanGame object takes no arguments; it constructs a CatanBoard and a number of CatanPlayer objects specified by a pulldown menu at launch. The CatanBoard initializes 37 CatanHex objects and calculates their position in a hexagonally tessellated area after randomizing the CatanHex objects according to the type of resource they represent. The CatanBoard object also initializes a Robber object; this robber object moves between CatanHex objects and neutralizes their resource (CatanHex.Type) properties by adding a tilde to the string, preventing matching with the resource collection algorithm. ProgCard and Card objects are initialized when the player collects the cards from the bank; Card inherits from ProgCard. The player can build objects of class Structure that are related to a CatanHex object; they have properties related to their position in the board. The objects of classes City, Settlement, and Road inherit from class Structure, while City inherits from class Settlement. These represent pieces in the game; this inheritance works because all pieces occupy board positions and have owners who are of class Player; a City is a more specific instance of class Settlement that supplants it on the board and is more valuable.

Manual
------

Start Settlers of Catan by calling “CatanGame;” in the command window. This will initialize the game and bring up a pop-up window with the options “Play” and “Load”. Click the play button, and you will be brought to a new window where you can select the amount of players from a drop down box -- a minimum of two players and a maximum of four. Once you have selected the amount of people who will be playing, click the “Begin Game” button to embark on your quest to Settle the lands of Catan!

The first step of the game is to decide the order of play. This is decided by having each player roll the dice, with the player who rolls highest earning the right to start the game. The next player will be the player with an index of one integer greater than the first, unless the first player has the highest index. For example, in a game of four players, if player 2 rolls highest, the second turn will belong to player 3, then 4, then 1. Note that if the highest roll is shared by two or more players, the process will repeat until one player owns the highest roll value.

The player who goes first must place his first settlement and road on a vertex and edge of one of the hexes, respectively. The GUI will guide you in placing your structures by putting push buttons where you need to make your selections.

In order to select strategic settlement locations, you should consider what resources are collectable on a vertex as well as the number on the hexes. Resources are collected at the beginning of each turn when a player rolls the dice. Anyone with a settlement on a vertex of a hex displaying the rolled value will collect a resource of that type. The types of resources are: brick (dark red), grain (yellow), lumber (forest green), ore (gray), and wool (bright green).

If a seven is rolled at the beginning of a turn, the robber will be triggered. This allows the player who rolled the seven to move the robber to any hex they choose. When a robber is on a hex, it will prevent resource collection by settlements or cities on vertices of that hex. It can only be moved when another seven is rolled, or when a Soldier Card is played.

Resources are used for building things or drawing development cards. A road requires one brick and one lumber to build, a settlement requires one brick, grain, lumber, and wool to build, and a city requires two grain and three ore, in addition to being placed on top of an existing settlement. Development cards can be drawn at the cost of one grain, one ore, and one wool.

It is advantageous to place settlements and cities, as they will collect resources for you faster, allowing you to place even more structures. A settlement that is upgraded to a city will collect two resources instead of one every time the number of an adjacent hex is rolled.

Development cards have multiple functions, the most common of which is the Soldier Card. This allows the player who played it to move the robber to any hex they choose. Another type of development card is the victory point card, which simply adds a victory point to the player’s total, and does not need to be played. The third type of development card is a road building card, which allows a player to build a road when the card is played. The monopoly development card allows the player to choose any of the five resource types, and all of the resources of that type owned by all of the players of the game are given to the player who played the monopoly card. The last development card type is the year of plenty card, which allows the user to add two of one resource to their hand.

At any time during a turn, the player may choose to trade resources with either another player or the bank. To trade resources with another player, the player whose turn it is must press the “Trade” button. This will bring up a pop-up window with two panels. The top panel is what you request from the other player, while the bottom panel is what you are willing to offer. Specify a player to trade to under the “Offer” button before you click it, and a new, similar pop-up window will be brought up. It will show what the trade offer is to the other player, and they will have the choice to accept or reject the trade. Trading with the bank is the same as trading with other players, except that you must trade four resources to receive one. The bank will always accept trades.

When the player is done with their turn, they must click the “End Turn” button to trigger a turn change. This allows the next player in the sequence to roll the dice and have opportunities to build or draw cards.

In order to win Settlers of Catan, one must accumulate 10 victory points. Victory points are earned by owning a settlement (1 point), owning a city (2 points), or owning victory point cards (1 point).



<p align="center"><img src="https://raw.githubusercontent.com/senselessdemon/rcmd/master/icon.png" width="30%" height="30%"></p>
<div align="center">
	<a href="https://discord.io/demonden">
		<img src="https://img.shields.io/badge/discord-server-blue.svg" alt="Discord" />
	</a>
	<a href="https://www.roblox.com/users/1811890178/profile">
		<img src="https://img.shields.io/badge/roblox-profile-red.svg" alt="Discord" />
	</a>
</div>

rCMD is a command executor and framework for use on the Roblox platform. It is meant to run at level 6, but can run on any level (with the drawback of some features). It features a wide variety of commands, and an object-oriented structure for a strong structure as well as the ease of future mantainance.
It's very simple to use. You can use either the entire script in your executor, or simply use a loadstring.
```
loadstring(game:HttpGet("https://raw.githubusercontent.com/senselessdemon/rcmd/master/init.lua", true))()
```
## Syntax
rCMD has a very readable and simple to understand syntax. Anyone with familiarity to admin system on Roblox will be immediately accustomed to rCMD's command system. The simple format is a command, followed by a series of arguments/parameters to tell the command what you want to do with it. The key that splits these is known as the split-key. It is by default a space. 

<b>Execution</b>
An execution is split by a split-key, which separates commands and arguments. By default it is a space, but if it were for example, a forward-slash `/`, an example command would look like:
```bash
echo/hello world
```
<b>Batches</b>
rCMD supports executing multiple commands in a single statement. This is done by utilizing different batches. A single batch holds a command along with its arguments. The default batch separator is `;`.
```bash
echo hello; echo world
```
<b>Special arguments</b>
Sometimes arguments can have their own syntax. A good example of this would be for players. When passing players, multiple players can be passed by using an argument-split-key (which by default is a comma).
```bash
person1,person2
```
Some player arguments also support inputting an argument parameter, such as ones that involve extra data, such as the one the allows you to target players in a certain group. This is done by using the argument-parameter-key (which by default is a hyphen/dash).
```
group-3336691,userid-1811890178
```
<b>Overriding</b>
Sometimes, you may want to have a single argument that contains the split-key (especially when it by default is a space). We can do this by putting the argument in quotes, just as is done by many programming languages.
```bash
echo "hello world"
```
In this case, `hello world` will be treated as 1 argument instead of being split into two.

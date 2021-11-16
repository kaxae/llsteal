const discord = require("discord.js"),
    fs = require('fs'), 
    mysql = require("mysql"),
    colors = require("colors"),
    superagent = require('superagent'),
    request = require('request'),
    config = require('./config.json'),
    cooldowns = new discord.Collection()

const bot = new discord.Client({disableEveryone: true})
bot.command = new discord.Collection()

const prefix = config.prefix

function log(text, color) {
    let d = new Date(),
        h = d.getHours(),
        m = d.getMinutes(),
        ap = "AM"
    if (h > 12) { h -= 12; ap = "PM" }
    if (m < 10) { m = "0" + m }
    time = h + ":" + m + " " + ap
 
    if (typeof(color) == "undefined") { console.log(colors.grey(time) + " : " + text) }
    if (typeof(color) != "undefined") { console.log(colors.grey(time) + " : " + colors[color](text)) }
}

fs.readdir('./command/', (err, files) => {
  if(err) log(err, "red")

  let jsfile = files.filter(f => f.split('.').pop() === 'js')
  if(jsfile.length <= 0) {
    log("không file để mở", "red")
    return
  }

  log('mở '+ jsfile.length +' file', "green")

  jsfile.forEach((f, i) => {
    let props = require('./command/'+ f)
    bot.command.set(props.help.name, props)
  })
})

function handleConnection() {
    con = mysql.createConnection(config.sql);
 
    con.connect(function(err) {
        if (err) {
            log("[ERROR] An error has occurred while connection: " + err, "red");
            log("[INFO] Attempting to establish connection with SQL database.", "yellow");
            setTimeout(handleConnection, 2000);
        } else {
            log("[SUCCESS] SQL database connection established successfully.", "green");
        }
    });
 
    con.on("error", function(err) {
        console.log("Error: " + err);
        if (err.code === "PROTOCOL_CONNECTION_LOST") {
            handleConnection();
        } else {
            throw err;
        }
    });
}

con = mysql.createConnection(config.sql);

con.connect(function(err) {
    if (err) {
        log("[ERROR] An error has occurred while connection: " + err, "red");
        log("[INFO] Attempting to establish connection with SQL database.", "yellow");
        setTimeout(handleConnection, 2000);
    } else {
        log("[SUCCESS] SQL database connection established successfully.", "green");
    }
});

con.on("error", function(err) {
    console.log("Error: " + err);
    if (err.code === "PROTOCOL_CONNECTION_LOST") {
        handleConnection();
    } else {
        throw err;
    }
});

function makeid(length) {
   var result           = '';
   var characters       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
   var charactersLength = characters.length;
   for ( var i = 0; i < length; i++ ) {
      result += characters.charAt(Math.floor(Math.random() * charactersLength));
   }
   return result;
}

bot.on("ready", () => { 
  log("Bot ON", "green")
})

bot.on("message", async message => {
    if (message.author.equals(bot.user)) return;
    if (!message.content.startsWith(config.prefix)) return;
    const messageArray = message.content.split(/\s+/g)
    const coa = messageArray[0]
    const args = message.content.slice(config.prefix.length).trim().split(/ +/g)
    const role = message.guild.roles.cache.find(role => role.name === 'Buyer');

    const cmd = bot.command.get(coa.slice(config.prefix.length))
    if(cmd) cmd.run(bot, message, con, log, role, makeid, args)
})


bot.login(config.token)
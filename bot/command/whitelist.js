const discord = module.require('discord.js')

module.exports.run = async (bot, message, con, log, role, makeid, args) => {
 if(message.member.roles.cache.some(role => role.name === 'Whitelister')){
    if(args[1]) {
        con.query(`SELECT discord_id FROM whitelistbot WHERE discord_id = '${args[1]}'`, function (err, results, fields) {
            if(results.length) {
                const Embed = new discord.MessageEmbed()
                .setColor('#0099ff')
                .setDescription('**Bot Whitelist**')
                .addField('Error',"```\n"+args[1]+" Had Whitelist, Can't Give Another\n```", true)
                .setTimestamp()
                message.channel.send(Embed)
            } else {
                con.query(`INSERT INTO whitelistbot (discord_id, userkey, hwid, ip, Blacklisted, Reason) VALUES ('${args[1]}', '${makeid(12)}', 'Unknown', 'Unknown', 'False', 'Unknown')`, function (err, results, fields) {
                    const Embed = new discord.MessageEmbed()
                    .setColor('#0099ff')
                    .setDescription('**Bot Whitelist**')
                    .addField('Success',"```\nAdd Whitelist "+args[1]+" Success\n```", true)
                    .setTimestamp()
                    message.channel.send(Embed)
                })
            }
        })
    } else {
        const Embed = new discord.MessageEmbed()
        .setColor('#0099ff')
        .setDescription('**Bot Whitelist**')
        .addField('Error','```\nPlease Send Id Disord\n```', true)
        .setTimestamp()
        message.channel.send(Embed)
        log(`[LOG Command] ${message.author.username}, Use Command Add Whitelist Not Id`, "red")
    }
    } else {
        const Embed = new discord.MessageEmbed()
        .setColor('#0099ff')
        .setDescription('**Bot Whitelist**')
        .addField('Error','```\nAre You Not Whitelister\n```', true)
        .setTimestamp()
        message.channel.send(Embed)
        log(`[LOG Command] ${message.author.username}, Use Command Add Whitelist`, "red")
    }
}

module.exports.help = {
  name: "whitelist"
}

const discord = module.require('discord.js')

module.exports.run = async (bot, message, con, log) => {
    con.query(`SELECT discord_id FROM whitelistbot WHERE discord_id = '${message.author.id}'`, function (err, results, fields) {
      if(!results.length) {
        const Embed = new discord.MessageEmbed()
        .setColor('#0099ff')
        .setDescription('**Bot Whitelist**')
        .addField('Error','```\nAre You Not Buyer\n```', true)
        .setTimestamp()
        message.channel.send(Embed)
      } else {
        con.query(`SELECT discord_id,Blacklisted FROM whitelistbot WHERE discord_id = '${message.author.id}'`, function (err, results, fields) {
          if(results[0].Blacklisted === "True") {
            const Embed = new discord.MessageEmbed()
            .setColor('#0099ff')
            .setDescription('**Bot Whitelist**')
            .addField('Error','```\nYou Are In Blacklist\n```', true)
            .setTimestamp()
            message.channel.send(Embed)
          } else {
            con.query(`SELECT userkey FROM whitelistbot WHERE discord_id = '${message.author.id}'`, function(err, results, fields) {
                let key = results[0].userkey
                const Embed = new discord.MessageEmbed()
                .setColor('#0099ff')
                .setDescription('**Bot Whitelist**')
                .addField('Script','```lua\ngetgenv().Key = "'+ key + '"\nlocal Exploit = secure_load and "Sentinel" or pebc_execute and "ProtoSmasher" or is_sirhurt_closure and "Sirhurt"\nloadstring(game:HttpGet("https://websitewhitelist.herokuapp.com/Script/?Key='+key+'&Exploit="..Exploit))()\n```', true)
                .setTimestamp()
                message.author.send(Embed).catch(error => {
                    const embed = new discord.MessageEmbed()
                    .setColor('#0099ff')
                    .setDescription('**Bot Whitelist**')
                    .addField('Send Message Fail','```\nI cannot message you, open your messages!\n```', true)
                    .setTimestamp()
                    message.channel.send(embed)
                })
            })
          }
        })
      }
  })
}

module.exports.help = {
  name: "script"
}
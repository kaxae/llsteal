const discord = module.require('discord.js')

module.exports.run = async (bot, message, con, log, role, makeid, args) => {
  con.query(`Select discord_id FROM whitelistbot Where discord_id = '${message.author.id}'`, function(err, results, fields) {
      if(!results.length) {
          const Embed = new discord.MessageEmbed()
          .setColor('#0099ff')
          .setDescription('**Bot Whitelist**')
          .addField('Error','```\nAre You Not Whitelist\n```', true)
          .setTimestamp()
          message.channel.send(Embed)
          log(`[LOG Command] ${message.author.username}, Use Command Reset Hwid`, "red")
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
            con.query(`Update whitelistbot Set hwid = 'Unknown' Where discord_id = '${message.author.id}'`, function(err, results, fields){
                const Embed = new discord.MessageEmbed()
                .setColor('#0099ff')
                .setDescription('**Bot Whitelist**')
                .addField('Success','```\nResethwid Hwid Success\n```', true)
                .setTimestamp()
                message.channel.send(Embed)
                log(`[LOG Command] ${message.author.username}, Use Command Reset Hwid`, "green")
            })
          }
        })
      }
  })
}

module.exports.help = {
  name: "resethwid"
}
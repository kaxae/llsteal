const discord = module.require('discord.js')

module.exports.run = async (bot, message, con, log, role) => {
    const Embedasdasd = new discord.MessageEmbed()
    .setColor('#0099ff')
    .setDescription('**Bot Whitelist**')
    .addField('Success',"```\n!info\n!getrole\n!blacklist {discord id} {reason}\n!unblacklist {discord id}\n!script\n!resethwid\n!whitelist {discord id}\n```", true)
    .setTimestamp()
    return message.channel.send(Embedasdasd)
}

module.exports.help = {
  name: "help"
}

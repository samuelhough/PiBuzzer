var os=require('os');
var ifaces=os.networkInterfaces();
var ip = null;
for (var dev in ifaces) {
  var alias=0;
  ifaces[dev].forEach(function(details){
    if (details.family=='IPv4') {
      ip = dev+(alias?':'+alias:'') + ' ' + details.address;
      ++alias;
    }
  });
}

module.exports = {
  ip: ip
}
local newdecoder = require ("Base/Json/decoder")
local newencoder = require ("Base/Json/encoder")
local sax = require ("Base/Json/sax")
-- If you need multiple contexts of decoder and/or encoder,
-- you can require decoder and/or encoder directly.
return {
	decode = newdecoder(),
	encode = newencoder(),
	newparser = sax.newparser,
	newfileparser = sax.newfileparser,
}

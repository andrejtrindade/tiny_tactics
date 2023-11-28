-- coords.lua
-- ==========

-- optimization note: coordinates for each level were combined into a single integer

coords = {}

coords.combined = split(
--        x-1          x-2          x-3          x-4          x-5          x-6          x-7          x-8          x-9
	"0x1200.8408, 0x0000.5407, 0x0500.6305, 0x0004.5609, 0x0b00.7307, 0x000a.5a11, 0x0b09.7709, 0x0014.5c0d, 0x2300.ac1e,".. -- base 1
	"0x0503.660b, 0x1a00.9917, 0x1a09.9918, 0x1204.8a12, 0x0b03.760f, 0x2d00.b60d, 0x0b10.7713, 0x230c.a918, 0x2d06.bb2b,".. -- base 2
	"0x050f.690e, 0x0509.6610, 0x2d1c.b714, 0x1a32.9920, 0x3800.cd20, 0x1a12.9925, 0x1a1b.9b24, 0x0518.6e3b, 0x2d11.bb34,".. -- base 3
	"0x0526.6607, 0x121f.890d, 0x0b2b.790a, 0x2326.9914, 0x1228.8917, 0x232f.992a, 0x4400.fd33, 0x441a.fd42, 0x440d.fd47,".. -- base 4
	"0x1a26.9916, 0x2315.a821, 0x2d2c.b622, 0x2d23.b927, 0x0b20.7b0f, 0x231d.a921, 0x380d.cb29, 0x1216.892e, 0x4427.fd46,".. -- base 5
	"0x1a2f.9308, 0x0b17.7918, 0x120e.8812, 0x3818.c813, 0x2d32.b612, 0x3937.c61c, 0x4534.eb23, 0x5300.fd4f, 0x5334.fc55,".. -- base 6
	"0x052c.6709, 0x0533.660a, 0x2338.960e, 0x0539.6612, 0x1231.8715, 0x0b39.f714, 0x3820.bb28, 0x6234.fc3b, 0x5327.fd5d,".. -- base 7
	"0x0020.5709, 0x2c38.970a, 0x0b34.7511, 0x7127.fd22, 0x621a.fd3d, 0x382b.cc46, 0x7134.fc4f, 0x6227.fd61, 0x531a.fd74,".. -- base 8
	"0x0027.5d0d, 0x1a3b.950e, 0x0034.590b, 0x530d.fd34, 0x710d.fd3c, 0x711a.fd42, 0x620d.fd7c, 0x6200.fd7d, 0x7100.fd63"    -- base 9
)

coords.num_levels = #(coords.combined)

coords.names = split(
--   x-1             x-2             x-3             x-4             x-5             x-6             x-7             x-8             x-9
	"run and gun    ,patience       ,initiative     ,retreat        ,gunslinger     ,outnumbered    ,cornered       ,left and right ,second sight   ,".. -- base 1
	"camper         ,cover          ,tip toe        ,offset         ,gimme a second ,opportunity    ,half past six  ,bad boys       ,cardinals      ,".. -- base 2
	"make some noise,human shield   ,deafening      ,open and close ,question mark  ,zigzag         ,echoes         ,back and forth ,cacophony      ,".. -- base 3
	"intercept      ,out of sync    ,vision blocked ,running behind ,clumsy         ,en passant     ,gatekeeping    ,crowded        ,asimmetry      ,".. -- base 4
	"sniper         ,circle strafe  ,whac-a-mole    ,sine wave      ,easy peasy     ,eyes and ears  ,evanescent     ,peripheral     ,serpentine     ,".. -- base 5
	"friendly fire  ,trigger happy  ,executioner    ,triple layered ,cramped        ,firing squad   ,shield to go   ,cannon fodder  ,methodical     ,".. -- base 6
	"coward         ,cat-and-mouse  ,choose wisely  ,free at last   ,sneaky         ,one at a time? ,double cover   ,sabotage       ,shadow         ,".. -- base 7
	"restrained     ,change of heart,bewildered     ,surrounded     ,tic-tac-toe    ,crowded        ,crumbs         ,labyrinth      ,sniper maze    ,".. -- base 8
	"no holds barred,turnaround     ,confined       ,adjustment time,the grid       ,wanted         ,flow managed   ,threadmill     ,the final level"    -- base 9
)

coords.x_mask = 0xff00
coords.y_mask =   0xff
coords.w_mask =    0x0.f
coords.h_mask =    0x0.0f
coords.d_mask =    0x0.00ff

coords.x           = function(this, i) return rotr(band(this.combined[i], this.x_mask), 8)  end
coords.y           = function(this, i) return      band(this.combined[i], this.y_mask)      end
coords.w           = function(this, i) return rotl(band(this.combined[i], this.w_mask), 4)  end
coords.h           = function(this, i) return rotl(band(this.combined[i], this.h_mask), 8)  end
coords.devs_record = function(this, i) return rotl(band(this.combined[i], this.d_mask), 16) end

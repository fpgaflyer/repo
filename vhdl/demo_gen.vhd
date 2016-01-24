library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity demo_gen is
	port(
		clk_in        : in  std_logic;
		reset         : in  std_logic;
		calc_offsets  : in  std_logic;
		demo_setpos_1 : out std_logic_vector(7 downto 0);
		demo_setpos_2 : out std_logic_vector(7 downto 0);
		demo_setpos_3 : out std_logic_vector(7 downto 0);
		demo_setpos_4 : out std_logic_vector(7 downto 0);
		demo_setpos_5 : out std_logic_vector(7 downto 0);
		demo_setpos_6 : out std_logic_vector(7 downto 0)
	);
end;

architecture behav of demo_gen is
	subtype ROM_WORD is STD_LOGIC_VECTOR(7 downto 0);
	type ROM_TABLE is array (0 to 360) of ROM_WORD;
	constant ROM : ROM_TABLE := ROM_TABLE'( -- amplitude = +/- 80
		ROM_WORD'("10000000"),          -- 0  128
		ROM_WORD'("10000001"),          -- 1  129
		ROM_WORD'("10000011"),          -- 2  131
		ROM_WORD'("10000100"),          -- 3  132
		ROM_WORD'("10000110"),          -- 4  134
		ROM_WORD'("10000111"),          -- 5  135
		ROM_WORD'("10001000"),          -- 6  136
		ROM_WORD'("10001010"),          -- 7  138
		ROM_WORD'("10001011"),          -- 8  139
		ROM_WORD'("10001101"),          -- 9  141
		ROM_WORD'("10001110"),          -- 10  142
		ROM_WORD'("10001111"),          -- 11  143
		ROM_WORD'("10010001"),          -- 12  145
		ROM_WORD'("10010010"),          -- 13  146
		ROM_WORD'("10010011"),          -- 14  147
		ROM_WORD'("10010101"),          -- 15  149
		ROM_WORD'("10010110"),          -- 16  150
		ROM_WORD'("10010111"),          -- 17  151
		ROM_WORD'("10011001"),          -- 18  153
		ROM_WORD'("10011010"),          -- 19  154
		ROM_WORD'("10011011"),          -- 20  155
		ROM_WORD'("10011101"),          -- 21  157
		ROM_WORD'("10011110"),          -- 22  158
		ROM_WORD'("10011111"),          -- 23  159
		ROM_WORD'("10100001"),          -- 24  161
		ROM_WORD'("10100010"),          -- 25  162
		ROM_WORD'("10100011"),          -- 26  163
		ROM_WORD'("10100100"),          -- 27  164
		ROM_WORD'("10100110"),          -- 28  166
		ROM_WORD'("10100111"),          -- 29  167
		ROM_WORD'("10101000"),          -- 30  168
		ROM_WORD'("10101001"),          -- 31  169
		ROM_WORD'("10101010"),          -- 32  170
		ROM_WORD'("10101100"),          -- 33  172
		ROM_WORD'("10101101"),          -- 34  173
		ROM_WORD'("10101110"),          -- 35  174
		ROM_WORD'("10101111"),          -- 36  175
		ROM_WORD'("10110000"),          -- 37  176
		ROM_WORD'("10110001"),          -- 38  177
		ROM_WORD'("10110010"),          -- 39  178
		ROM_WORD'("10110011"),          -- 40  179
		ROM_WORD'("10110100"),          -- 41  180
		ROM_WORD'("10110110"),          -- 42  182
		ROM_WORD'("10110111"),          -- 43  183
		ROM_WORD'("10111000"),          -- 44  184
		ROM_WORD'("10111001"),          -- 45  185
		ROM_WORD'("10111010"),          -- 46  186
		ROM_WORD'("10111011"),          -- 47  187
		ROM_WORD'("10111011"),          -- 48  187
		ROM_WORD'("10111100"),          -- 49  188
		ROM_WORD'("10111101"),          -- 50  189
		ROM_WORD'("10111110"),          -- 51  190
		ROM_WORD'("10111111"),          -- 52  191
		ROM_WORD'("11000000"),          -- 53  192
		ROM_WORD'("11000001"),          -- 54  193
		ROM_WORD'("11000010"),          -- 55  194
		ROM_WORD'("11000010"),          -- 56  194
		ROM_WORD'("11000011"),          -- 57  195
		ROM_WORD'("11000100"),          -- 58  196
		ROM_WORD'("11000101"),          -- 59  197
		ROM_WORD'("11000101"),          -- 60  197
		ROM_WORD'("11000110"),          -- 61  198
		ROM_WORD'("11000111"),          -- 62  199
		ROM_WORD'("11000111"),          -- 63  199
		ROM_WORD'("11001000"),          -- 64  200
		ROM_WORD'("11001001"),          -- 65  201
		ROM_WORD'("11001001"),          -- 66  201
		ROM_WORD'("11001010"),          -- 67  202
		ROM_WORD'("11001010"),          -- 68  202
		ROM_WORD'("11001011"),          -- 69  203
		ROM_WORD'("11001011"),          -- 70  203
		ROM_WORD'("11001100"),          -- 71  204
		ROM_WORD'("11001100"),          -- 72  204
		ROM_WORD'("11001101"),          -- 73  205
		ROM_WORD'("11001101"),          -- 74  205
		ROM_WORD'("11001101"),          -- 75  205
		ROM_WORD'("11001110"),          -- 76  206
		ROM_WORD'("11001110"),          -- 77  206
		ROM_WORD'("11001110"),          -- 78  206
		ROM_WORD'("11001111"),          -- 79  207
		ROM_WORD'("11001111"),          -- 80  207
		ROM_WORD'("11001111"),          -- 81  207
		ROM_WORD'("11001111"),          -- 82  207
		ROM_WORD'("11001111"),          -- 83  207
		ROM_WORD'("11010000"),          -- 84  208
		ROM_WORD'("11010000"),          -- 85  208
		ROM_WORD'("11010000"),          -- 86  208
		ROM_WORD'("11010000"),          -- 87  208
		ROM_WORD'("11010000"),          -- 88  208
		ROM_WORD'("11010000"),          -- 89  208
		ROM_WORD'("11010000"),          -- 90  208
		ROM_WORD'("11010000"),          -- 91  208
		ROM_WORD'("11010000"),          -- 92  208
		ROM_WORD'("11010000"),          -- 93  208
		ROM_WORD'("11010000"),          -- 94  208
		ROM_WORD'("11010000"),          -- 95  208
		ROM_WORD'("11010000"),          -- 96  208
		ROM_WORD'("11001111"),          -- 97  207
		ROM_WORD'("11001111"),          -- 98  207
		ROM_WORD'("11001111"),          -- 99  207
		ROM_WORD'("11001111"),          -- 100  207
		ROM_WORD'("11001111"),          -- 101  207
		ROM_WORD'("11001110"),          -- 102  206
		ROM_WORD'("11001110"),          -- 103  206
		ROM_WORD'("11001110"),          -- 104  206
		ROM_WORD'("11001101"),          -- 105  205
		ROM_WORD'("11001101"),          -- 106  205
		ROM_WORD'("11001101"),          -- 107  205
		ROM_WORD'("11001100"),          -- 108  204
		ROM_WORD'("11001100"),          -- 109  204
		ROM_WORD'("11001011"),          -- 110  203
		ROM_WORD'("11001011"),          -- 111  203
		ROM_WORD'("11001010"),          -- 112  202
		ROM_WORD'("11001010"),          -- 113  202
		ROM_WORD'("11001001"),          -- 114  201
		ROM_WORD'("11001001"),          -- 115  201
		ROM_WORD'("11001000"),          -- 116  200
		ROM_WORD'("11000111"),          -- 117  199
		ROM_WORD'("11000111"),          -- 118  199
		ROM_WORD'("11000110"),          -- 119  198
		ROM_WORD'("11000101"),          -- 120  197
		ROM_WORD'("11000101"),          -- 121  197
		ROM_WORD'("11000100"),          -- 122  196
		ROM_WORD'("11000011"),          -- 123  195
		ROM_WORD'("11000010"),          -- 124  194
		ROM_WORD'("11000010"),          -- 125  194
		ROM_WORD'("11000001"),          -- 126  193
		ROM_WORD'("11000000"),          -- 127  192
		ROM_WORD'("10111111"),          -- 128  191
		ROM_WORD'("10111110"),          -- 129  190
		ROM_WORD'("10111101"),          -- 130  189
		ROM_WORD'("10111100"),          -- 131  188
		ROM_WORD'("10111011"),          -- 132  187
		ROM_WORD'("10111011"),          -- 133  187
		ROM_WORD'("10111010"),          -- 134  186
		ROM_WORD'("10111001"),          -- 135  185
		ROM_WORD'("10111000"),          -- 136  184
		ROM_WORD'("10110111"),          -- 137  183
		ROM_WORD'("10110110"),          -- 138  182
		ROM_WORD'("10110100"),          -- 139  180
		ROM_WORD'("10110011"),          -- 140  179
		ROM_WORD'("10110010"),          -- 141  178
		ROM_WORD'("10110001"),          -- 142  177
		ROM_WORD'("10110000"),          -- 143  176
		ROM_WORD'("10101111"),          -- 144  175
		ROM_WORD'("10101110"),          -- 145  174
		ROM_WORD'("10101101"),          -- 146  173
		ROM_WORD'("10101100"),          -- 147  172
		ROM_WORD'("10101010"),          -- 148  170
		ROM_WORD'("10101001"),          -- 149  169
		ROM_WORD'("10101000"),          -- 150  168
		ROM_WORD'("10100111"),          -- 151  167
		ROM_WORD'("10100110"),          -- 152  166
		ROM_WORD'("10100100"),          -- 153  164
		ROM_WORD'("10100011"),          -- 154  163
		ROM_WORD'("10100010"),          -- 155  162
		ROM_WORD'("10100001"),          -- 156  161
		ROM_WORD'("10011111"),          -- 157  159
		ROM_WORD'("10011110"),          -- 158  158
		ROM_WORD'("10011101"),          -- 159  157
		ROM_WORD'("10011011"),          -- 160  155
		ROM_WORD'("10011010"),          -- 161  154
		ROM_WORD'("10011001"),          -- 162  153
		ROM_WORD'("10010111"),          -- 163  151
		ROM_WORD'("10010110"),          -- 164  150
		ROM_WORD'("10010101"),          -- 165  149
		ROM_WORD'("10010011"),          -- 166  147
		ROM_WORD'("10010010"),          -- 167  146
		ROM_WORD'("10010001"),          -- 168  145
		ROM_WORD'("10001111"),          -- 169  143
		ROM_WORD'("10001110"),          -- 170  142
		ROM_WORD'("10001101"),          -- 171  141
		ROM_WORD'("10001011"),          -- 172  139
		ROM_WORD'("10001010"),          -- 173  138
		ROM_WORD'("10001000"),          -- 174  136
		ROM_WORD'("10000111"),          -- 175  135
		ROM_WORD'("10000110"),          -- 176  134
		ROM_WORD'("10000100"),          -- 177  132
		ROM_WORD'("10000011"),          -- 178  131
		ROM_WORD'("10000001"),          -- 179  129
		ROM_WORD'("10000000"),          -- 180  128
		ROM_WORD'("01111111"),          -- 181  127
		ROM_WORD'("01111101"),          -- 182  125
		ROM_WORD'("01111100"),          -- 183  124
		ROM_WORD'("01111010"),          -- 184  122
		ROM_WORD'("01111001"),          -- 185  121
		ROM_WORD'("01111000"),          -- 186  120
		ROM_WORD'("01110110"),          -- 187  118
		ROM_WORD'("01110101"),          -- 188  117
		ROM_WORD'("01110011"),          -- 189  115
		ROM_WORD'("01110010"),          -- 190  114
		ROM_WORD'("01110001"),          -- 191  113
		ROM_WORD'("01101111"),          -- 192  111
		ROM_WORD'("01101110"),          -- 193  110
		ROM_WORD'("01101101"),          -- 194  109
		ROM_WORD'("01101011"),          -- 195  107
		ROM_WORD'("01101010"),          -- 196  106
		ROM_WORD'("01101001"),          -- 197  105
		ROM_WORD'("01100111"),          -- 198  103
		ROM_WORD'("01100110"),          -- 199  102
		ROM_WORD'("01100101"),          -- 200  101
		ROM_WORD'("01100011"),          -- 201  99
		ROM_WORD'("01100010"),          -- 202  98
		ROM_WORD'("01100001"),          -- 203  97
		ROM_WORD'("01011111"),          -- 204  95
		ROM_WORD'("01011110"),          -- 205  94
		ROM_WORD'("01011101"),          -- 206  93
		ROM_WORD'("01011100"),          -- 207  92
		ROM_WORD'("01011010"),          -- 208  90
		ROM_WORD'("01011001"),          -- 209  89
		ROM_WORD'("01011000"),          -- 210  88
		ROM_WORD'("01010111"),          -- 211  87
		ROM_WORD'("01010110"),          -- 212  86
		ROM_WORD'("01010100"),          -- 213  84
		ROM_WORD'("01010011"),          -- 214  83
		ROM_WORD'("01010010"),          -- 215  82
		ROM_WORD'("01010001"),          -- 216  81
		ROM_WORD'("01010000"),          -- 217  80
		ROM_WORD'("01001111"),          -- 218  79
		ROM_WORD'("01001110"),          -- 219  78
		ROM_WORD'("01001101"),          -- 220  77
		ROM_WORD'("01001100"),          -- 221  76
		ROM_WORD'("01001010"),          -- 222  74
		ROM_WORD'("01001001"),          -- 223  73
		ROM_WORD'("01001000"),          -- 224  72
		ROM_WORD'("01000111"),          -- 225  71
		ROM_WORD'("01000110"),          -- 226  70
		ROM_WORD'("01000101"),          -- 227  69
		ROM_WORD'("01000101"),          -- 228  69
		ROM_WORD'("01000100"),          -- 229  68
		ROM_WORD'("01000011"),          -- 230  67
		ROM_WORD'("01000010"),          -- 231  66
		ROM_WORD'("01000001"),          -- 232  65
		ROM_WORD'("01000000"),          -- 233  64
		ROM_WORD'("00111111"),          -- 234  63
		ROM_WORD'("00111110"),          -- 235  62
		ROM_WORD'("00111110"),          -- 236  62
		ROM_WORD'("00111101"),          -- 237  61
		ROM_WORD'("00111100"),          -- 238  60
		ROM_WORD'("00111011"),          -- 239  59
		ROM_WORD'("00111011"),          -- 240  59
		ROM_WORD'("00111010"),          -- 241  58
		ROM_WORD'("00111001"),          -- 242  57
		ROM_WORD'("00111001"),          -- 243  57
		ROM_WORD'("00111000"),          -- 244  56
		ROM_WORD'("00110111"),          -- 245  55
		ROM_WORD'("00110111"),          -- 246  55
		ROM_WORD'("00110110"),          -- 247  54
		ROM_WORD'("00110110"),          -- 248  54
		ROM_WORD'("00110101"),          -- 249  53
		ROM_WORD'("00110101"),          -- 250  53
		ROM_WORD'("00110100"),          -- 251  52
		ROM_WORD'("00110100"),          -- 252  52
		ROM_WORD'("00110011"),          -- 253  51
		ROM_WORD'("00110011"),          -- 254  51
		ROM_WORD'("00110011"),          -- 255  51
		ROM_WORD'("00110010"),          -- 256  50
		ROM_WORD'("00110010"),          -- 257  50
		ROM_WORD'("00110010"),          -- 258  50
		ROM_WORD'("00110001"),          -- 259  49
		ROM_WORD'("00110001"),          -- 260  49
		ROM_WORD'("00110001"),          -- 261  49
		ROM_WORD'("00110001"),          -- 262  49
		ROM_WORD'("00110001"),          -- 263  49
		ROM_WORD'("00110000"),          -- 264  48
		ROM_WORD'("00110000"),          -- 265  48
		ROM_WORD'("00110000"),          -- 266  48
		ROM_WORD'("00110000"),          -- 267  48
		ROM_WORD'("00110000"),          -- 268  48
		ROM_WORD'("00110000"),          -- 269  48
		ROM_WORD'("00110000"),          -- 270  48
		ROM_WORD'("00110000"),          -- 271  48
		ROM_WORD'("00110000"),          -- 272  48
		ROM_WORD'("00110000"),          -- 273  48
		ROM_WORD'("00110000"),          -- 274  48
		ROM_WORD'("00110000"),          -- 275  48
		ROM_WORD'("00110000"),          -- 276  48
		ROM_WORD'("00110001"),          -- 277  49
		ROM_WORD'("00110001"),          -- 278  49
		ROM_WORD'("00110001"),          -- 279  49
		ROM_WORD'("00110001"),          -- 280  49
		ROM_WORD'("00110001"),          -- 281  49
		ROM_WORD'("00110010"),          -- 282  50
		ROM_WORD'("00110010"),          -- 283  50
		ROM_WORD'("00110010"),          -- 284  50
		ROM_WORD'("00110011"),          -- 285  51
		ROM_WORD'("00110011"),          -- 286  51
		ROM_WORD'("00110011"),          -- 287  51
		ROM_WORD'("00110100"),          -- 288  52
		ROM_WORD'("00110100"),          -- 289  52
		ROM_WORD'("00110101"),          -- 290  53
		ROM_WORD'("00110101"),          -- 291  53
		ROM_WORD'("00110110"),          -- 292  54
		ROM_WORD'("00110110"),          -- 293  54
		ROM_WORD'("00110111"),          -- 294  55
		ROM_WORD'("00110111"),          -- 295  55
		ROM_WORD'("00111000"),          -- 296  56
		ROM_WORD'("00111001"),          -- 297  57
		ROM_WORD'("00111001"),          -- 298  57
		ROM_WORD'("00111010"),          -- 299  58
		ROM_WORD'("00111011"),          -- 300  59
		ROM_WORD'("00111011"),          -- 301  59
		ROM_WORD'("00111100"),          -- 302  60
		ROM_WORD'("00111101"),          -- 303  61
		ROM_WORD'("00111110"),          -- 304  62
		ROM_WORD'("00111110"),          -- 305  62
		ROM_WORD'("00111111"),          -- 306  63
		ROM_WORD'("01000000"),          -- 307  64
		ROM_WORD'("01000001"),          -- 308  65
		ROM_WORD'("01000010"),          -- 309  66
		ROM_WORD'("01000011"),          -- 310  67
		ROM_WORD'("01000100"),          -- 311  68
		ROM_WORD'("01000101"),          -- 312  69
		ROM_WORD'("01000101"),          -- 313  69
		ROM_WORD'("01000110"),          -- 314  70
		ROM_WORD'("01000111"),          -- 315  71
		ROM_WORD'("01001000"),          -- 316  72
		ROM_WORD'("01001001"),          -- 317  73
		ROM_WORD'("01001010"),          -- 318  74
		ROM_WORD'("01001100"),          -- 319  76
		ROM_WORD'("01001101"),          -- 320  77
		ROM_WORD'("01001110"),          -- 321  78
		ROM_WORD'("01001111"),          -- 322  79
		ROM_WORD'("01010000"),          -- 323  80
		ROM_WORD'("01010001"),          -- 324  81
		ROM_WORD'("01010010"),          -- 325  82
		ROM_WORD'("01010011"),          -- 326  83
		ROM_WORD'("01010100"),          -- 327  84
		ROM_WORD'("01010110"),          -- 328  86
		ROM_WORD'("01010111"),          -- 329  87
		ROM_WORD'("01011000"),          -- 330  88
		ROM_WORD'("01011001"),          -- 331  89
		ROM_WORD'("01011010"),          -- 332  90
		ROM_WORD'("01011100"),          -- 333  92
		ROM_WORD'("01011101"),          -- 334  93
		ROM_WORD'("01011110"),          -- 335  94
		ROM_WORD'("01011111"),          -- 336  95
		ROM_WORD'("01100001"),          -- 337  97
		ROM_WORD'("01100010"),          -- 338  98
		ROM_WORD'("01100011"),          -- 339  99
		ROM_WORD'("01100101"),          -- 340  101
		ROM_WORD'("01100110"),          -- 341  102
		ROM_WORD'("01100111"),          -- 342  103
		ROM_WORD'("01101001"),          -- 343  105
		ROM_WORD'("01101010"),          -- 344  106
		ROM_WORD'("01101011"),          -- 345  107
		ROM_WORD'("01101101"),          -- 346  109
		ROM_WORD'("01101110"),          -- 347  110
		ROM_WORD'("01101111"),          -- 348  111
		ROM_WORD'("01110001"),          -- 349  113
		ROM_WORD'("01110010"),          -- 350  114
		ROM_WORD'("01110011"),          -- 351  115
		ROM_WORD'("01110101"),          -- 352  117
		ROM_WORD'("01110110"),          -- 353  118
		ROM_WORD'("01111000"),          -- 354  120
		ROM_WORD'("01111001"),          -- 355  121
		ROM_WORD'("01111010"),          -- 356  122
		ROM_WORD'("01111100"),          -- 357  124
		ROM_WORD'("01111101"),          -- 358  125
		ROM_WORD'("01111111"),          -- 359  127
		ROM_WORD'("10000000")           -- 360  128
	);
	signal degree : integer range 0 to 360;
	type t_offset is array (1 to 6) of integer range 0 to 360;
	signal offset : t_offset;
	type t_degr is array (1 to 6) of integer range 0 to 360;
	signal degr           : t_degr;
	signal shiftreg       : std_logic_vector(23 downto 0);
	signal calc_offsets_d : std_logic;

begin
	process
		variable fb : std_logic;

	begin
		wait until clk_in = '1';

		if reset = '1' then             -- need long reset if clk_in is low freq !!
			shiftreg <= (others => '1');
			for i in 1 to 6 loop
				offset(i) <= 0;
			end loop;
		else
			calc_offsets_d <= calc_offsets;
			fb             := shiftreg(23) xor shiftreg(22) xor shiftreg(21) xor shiftreg(16);
			shiftreg       <= shiftreg(22 downto 0) & fb; -- linear feedback shift register 

			if calc_offsets = '1' and calc_offsets_d = '0' then --rising edge
				offset(1) <= conv_integer(shiftreg(23 downto 20)) * 24;
				offset(2) <= conv_integer(shiftreg(19 downto 16)) * 24;
				offset(3) <= conv_integer(shiftreg(15 downto 12)) * 24;
				offset(4) <= conv_integer(shiftreg(11 downto 8)) * 24;
				offset(5) <= conv_integer(shiftreg(7 downto 4)) * 24;
				offset(6) <= conv_integer(shiftreg(3 downto 0)) * 24;
			end if;

			if degree = 360 then
				degree <= 0;
			else
				degree <= degree + 1;
			end if;

			for i in 1 to 6 loop
				if degree > (360 - offset(i)) then
					degr(i) <= degree - (360 - offset(i));
				else
					degr(i) <= degree + offset(i);
				end if;
			end loop;

			demo_setpos_1 <= ROM(degr(1));
			demo_setpos_2 <= ROM(degr(2));
			demo_setpos_3 <= ROM(degr(3));
			demo_setpos_4 <= ROM(degr(4));
			demo_setpos_5 <= ROM(degr(5));
			demo_setpos_6 <= ROM(degr(6));

		end if;

	end process;
end;
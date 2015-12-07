library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity sinus_rom is
	port(
		clk_in       : in  std_logic;
		mode         : in  std_logic_vector(3 downto 0);
		sin_setpos_1 : out std_logic_vector(7 downto 0);
		sin_setpos_2 : out std_logic_vector(7 downto 0);
		sin_setpos_3 : out std_logic_vector(7 downto 0);
		sin_setpos_4 : out std_logic_vector(7 downto 0);
		sin_setpos_5 : out std_logic_vector(7 downto 0);
		sin_setpos_6 : out std_logic_vector(7 downto 0)
	);
end;

architecture behav of sinus_rom is
	subtype ROM_WORD is STD_LOGIC_VECTOR(7 downto 0);
	type ROM_TABLE is array (0 to 359) of ROM_WORD;
	constant ROM : ROM_TABLE := ROM_TABLE'( -- amplitude = +/- 64
		ROM_WORD'("10000000"),          -- 0  128
		ROM_WORD'("10000001"),          -- 1  129
		ROM_WORD'("10000010"),          -- 2  130
		ROM_WORD'("10000011"),          -- 3  131
		ROM_WORD'("10000100"),          -- 4  132
		ROM_WORD'("10000110"),          -- 5  134
		ROM_WORD'("10000111"),          -- 6  135
		ROM_WORD'("10001000"),          -- 7  136
		ROM_WORD'("10001001"),          -- 8  137
		ROM_WORD'("10001010"),          -- 9  138
		ROM_WORD'("10001011"),          -- 10  139
		ROM_WORD'("10001100"),          -- 11  140
		ROM_WORD'("10001101"),          -- 12  141
		ROM_WORD'("10001110"),          -- 13  142
		ROM_WORD'("10001111"),          -- 14  143
		ROM_WORD'("10010001"),          -- 15  145
		ROM_WORD'("10010010"),          -- 16  146
		ROM_WORD'("10010011"),          -- 17  147
		ROM_WORD'("10010100"),          -- 18  148
		ROM_WORD'("10010101"),          -- 19  149
		ROM_WORD'("10010110"),          -- 20  150
		ROM_WORD'("10010111"),          -- 21  151
		ROM_WORD'("10011000"),          -- 22  152
		ROM_WORD'("10011001"),          -- 23  153
		ROM_WORD'("10011010"),          -- 24  154
		ROM_WORD'("10011011"),          -- 25  155
		ROM_WORD'("10011100"),          -- 26  156
		ROM_WORD'("10011101"),          -- 27  157
		ROM_WORD'("10011110"),          -- 28  158
		ROM_WORD'("10011111"),          -- 29  159
		ROM_WORD'("10100000"),          -- 30  160
		ROM_WORD'("10100001"),          -- 31  161
		ROM_WORD'("10100010"),          -- 32  162
		ROM_WORD'("10100011"),          -- 33  163
		ROM_WORD'("10100100"),          -- 34  164
		ROM_WORD'("10100101"),          -- 35  165
		ROM_WORD'("10100110"),          -- 36  166
		ROM_WORD'("10100111"),          -- 37  167
		ROM_WORD'("10100111"),          -- 38  167
		ROM_WORD'("10101000"),          -- 39  168
		ROM_WORD'("10101001"),          -- 40  169
		ROM_WORD'("10101010"),          -- 41  170
		ROM_WORD'("10101011"),          -- 42  171
		ROM_WORD'("10101100"),          -- 43  172
		ROM_WORD'("10101100"),          -- 44  172
		ROM_WORD'("10101101"),          -- 45  173
		ROM_WORD'("10101110"),          -- 46  174
		ROM_WORD'("10101111"),          -- 47  175
		ROM_WORD'("10110000"),          -- 48  176
		ROM_WORD'("10110000"),          -- 49  176
		ROM_WORD'("10110001"),          -- 50  177
		ROM_WORD'("10110010"),          -- 51  178
		ROM_WORD'("10110010"),          -- 52  178
		ROM_WORD'("10110011"),          -- 53  179
		ROM_WORD'("10110100"),          -- 54  180
		ROM_WORD'("10110100"),          -- 55  180
		ROM_WORD'("10110101"),          -- 56  181
		ROM_WORD'("10110110"),          -- 57  182
		ROM_WORD'("10110110"),          -- 58  182
		ROM_WORD'("10110111"),          -- 59  183
		ROM_WORD'("10110111"),          -- 60  183
		ROM_WORD'("10111000"),          -- 61  184
		ROM_WORD'("10111001"),          -- 62  185
		ROM_WORD'("10111001"),          -- 63  185
		ROM_WORD'("10111010"),          -- 64  186
		ROM_WORD'("10111010"),          -- 65  186
		ROM_WORD'("10111010"),          -- 66  186
		ROM_WORD'("10111011"),          -- 67  187
		ROM_WORD'("10111011"),          -- 68  187
		ROM_WORD'("10111100"),          -- 69  188
		ROM_WORD'("10111100"),          -- 70  188
		ROM_WORD'("10111101"),          -- 71  189
		ROM_WORD'("10111101"),          -- 72  189
		ROM_WORD'("10111101"),          -- 73  189
		ROM_WORD'("10111110"),          -- 74  190
		ROM_WORD'("10111110"),          -- 75  190
		ROM_WORD'("10111110"),          -- 76  190
		ROM_WORD'("10111110"),          -- 77  190
		ROM_WORD'("10111111"),          -- 78  191
		ROM_WORD'("10111111"),          -- 79  191
		ROM_WORD'("10111111"),          -- 80  191
		ROM_WORD'("10111111"),          -- 81  191
		ROM_WORD'("10111111"),          -- 82  191
		ROM_WORD'("11000000"),          -- 83  192
		ROM_WORD'("11000000"),          -- 84  192
		ROM_WORD'("11000000"),          -- 85  192
		ROM_WORD'("11000000"),          -- 86  192
		ROM_WORD'("11000000"),          -- 87  192
		ROM_WORD'("11000000"),          -- 88  192
		ROM_WORD'("11000000"),          -- 89  192
		ROM_WORD'("11000000"),          -- 90  192
		ROM_WORD'("11000000"),          -- 91  192
		ROM_WORD'("11000000"),          -- 92  192
		ROM_WORD'("11000000"),          -- 93  192
		ROM_WORD'("11000000"),          -- 94  192
		ROM_WORD'("11000000"),          -- 95  192
		ROM_WORD'("11000000"),          -- 96  192
		ROM_WORD'("11000000"),          -- 97  192
		ROM_WORD'("10111111"),          -- 98  191
		ROM_WORD'("10111111"),          -- 99  191
		ROM_WORD'("10111111"),          -- 100  191
		ROM_WORD'("10111111"),          -- 101  191
		ROM_WORD'("10111111"),          -- 102  191
		ROM_WORD'("10111110"),          -- 103  190
		ROM_WORD'("10111110"),          -- 104  190
		ROM_WORD'("10111110"),          -- 105  190
		ROM_WORD'("10111110"),          -- 106  190
		ROM_WORD'("10111101"),          -- 107  189
		ROM_WORD'("10111101"),          -- 108  189
		ROM_WORD'("10111101"),          -- 109  189
		ROM_WORD'("10111100"),          -- 110  188
		ROM_WORD'("10111100"),          -- 111  188
		ROM_WORD'("10111011"),          -- 112  187
		ROM_WORD'("10111011"),          -- 113  187
		ROM_WORD'("10111010"),          -- 114  186
		ROM_WORD'("10111010"),          -- 115  186
		ROM_WORD'("10111010"),          -- 116  186
		ROM_WORD'("10111001"),          -- 117  185
		ROM_WORD'("10111001"),          -- 118  185
		ROM_WORD'("10111000"),          -- 119  184
		ROM_WORD'("10110111"),          -- 120  183
		ROM_WORD'("10110111"),          -- 121  183
		ROM_WORD'("10110110"),          -- 122  182
		ROM_WORD'("10110110"),          -- 123  182
		ROM_WORD'("10110101"),          -- 124  181
		ROM_WORD'("10110100"),          -- 125  180
		ROM_WORD'("10110100"),          -- 126  180
		ROM_WORD'("10110011"),          -- 127  179
		ROM_WORD'("10110010"),          -- 128  178
		ROM_WORD'("10110010"),          -- 129  178
		ROM_WORD'("10110001"),          -- 130  177
		ROM_WORD'("10110000"),          -- 131  176
		ROM_WORD'("10110000"),          -- 132  176
		ROM_WORD'("10101111"),          -- 133  175
		ROM_WORD'("10101110"),          -- 134  174
		ROM_WORD'("10101101"),          -- 135  173
		ROM_WORD'("10101100"),          -- 136  172
		ROM_WORD'("10101100"),          -- 137  172
		ROM_WORD'("10101011"),          -- 138  171
		ROM_WORD'("10101010"),          -- 139  170
		ROM_WORD'("10101001"),          -- 140  169
		ROM_WORD'("10101000"),          -- 141  168
		ROM_WORD'("10100111"),          -- 142  167
		ROM_WORD'("10100111"),          -- 143  167
		ROM_WORD'("10100110"),          -- 144  166
		ROM_WORD'("10100101"),          -- 145  165
		ROM_WORD'("10100100"),          -- 146  164
		ROM_WORD'("10100011"),          -- 147  163
		ROM_WORD'("10100010"),          -- 148  162
		ROM_WORD'("10100001"),          -- 149  161
		ROM_WORD'("10100000"),          -- 150  160
		ROM_WORD'("10011111"),          -- 151  159
		ROM_WORD'("10011110"),          -- 152  158
		ROM_WORD'("10011101"),          -- 153  157
		ROM_WORD'("10011100"),          -- 154  156
		ROM_WORD'("10011011"),          -- 155  155
		ROM_WORD'("10011010"),          -- 156  154
		ROM_WORD'("10011001"),          -- 157  153
		ROM_WORD'("10011000"),          -- 158  152
		ROM_WORD'("10010111"),          -- 159  151
		ROM_WORD'("10010110"),          -- 160  150
		ROM_WORD'("10010101"),          -- 161  149
		ROM_WORD'("10010100"),          -- 162  148
		ROM_WORD'("10010011"),          -- 163  147
		ROM_WORD'("10010010"),          -- 164  146
		ROM_WORD'("10010001"),          -- 165  145
		ROM_WORD'("10001111"),          -- 166  143
		ROM_WORD'("10001110"),          -- 167  142
		ROM_WORD'("10001101"),          -- 168  141
		ROM_WORD'("10001100"),          -- 169  140
		ROM_WORD'("10001011"),          -- 170  139
		ROM_WORD'("10001010"),          -- 171  138
		ROM_WORD'("10001001"),          -- 172  137
		ROM_WORD'("10001000"),          -- 173  136
		ROM_WORD'("10000111"),          -- 174  135
		ROM_WORD'("10000110"),          -- 175  134
		ROM_WORD'("10000100"),          -- 176  132
		ROM_WORD'("10000011"),          -- 177  131
		ROM_WORD'("10000010"),          -- 178  130
		ROM_WORD'("10000001"),          -- 179  129
		ROM_WORD'("10000000"),          -- 180  128
		ROM_WORD'("01111111"),          -- 181  127
		ROM_WORD'("01111110"),          -- 182  126
		ROM_WORD'("01111101"),          -- 183  125
		ROM_WORD'("01111100"),          -- 184  124
		ROM_WORD'("01111010"),          -- 185  122
		ROM_WORD'("01111001"),          -- 186  121
		ROM_WORD'("01111000"),          -- 187  120
		ROM_WORD'("01110111"),          -- 188  119
		ROM_WORD'("01110110"),          -- 189  118
		ROM_WORD'("01110101"),          -- 190  117
		ROM_WORD'("01110100"),          -- 191  116
		ROM_WORD'("01110011"),          -- 192  115
		ROM_WORD'("01110010"),          -- 193  114
		ROM_WORD'("01110001"),          -- 194  113
		ROM_WORD'("01101111"),          -- 195  111
		ROM_WORD'("01101110"),          -- 196  110
		ROM_WORD'("01101101"),          -- 197  109
		ROM_WORD'("01101100"),          -- 198  108
		ROM_WORD'("01101011"),          -- 199  107
		ROM_WORD'("01101010"),          -- 200  106
		ROM_WORD'("01101001"),          -- 201  105
		ROM_WORD'("01101000"),          -- 202  104
		ROM_WORD'("01100111"),          -- 203  103
		ROM_WORD'("01100110"),          -- 204  102
		ROM_WORD'("01100101"),          -- 205  101
		ROM_WORD'("01100100"),          -- 206  100
		ROM_WORD'("01100011"),          -- 207  99
		ROM_WORD'("01100010"),          -- 208  98
		ROM_WORD'("01100001"),          -- 209  97
		ROM_WORD'("01100000"),          -- 210  96
		ROM_WORD'("01011111"),          -- 211  95
		ROM_WORD'("01011110"),          -- 212  94
		ROM_WORD'("01011101"),          -- 213  93
		ROM_WORD'("01011100"),          -- 214  92
		ROM_WORD'("01011011"),          -- 215  91
		ROM_WORD'("01011010"),          -- 216  90
		ROM_WORD'("01011001"),          -- 217  89
		ROM_WORD'("01011001"),          -- 218  89
		ROM_WORD'("01011000"),          -- 219  88
		ROM_WORD'("01010111"),          -- 220  87
		ROM_WORD'("01010110"),          -- 221  86
		ROM_WORD'("01010101"),          -- 222  85
		ROM_WORD'("01010100"),          -- 223  84
		ROM_WORD'("01010100"),          -- 224  84
		ROM_WORD'("01010011"),          -- 225  83
		ROM_WORD'("01010010"),          -- 226  82
		ROM_WORD'("01010001"),          -- 227  81
		ROM_WORD'("01010000"),          -- 228  80
		ROM_WORD'("01010000"),          -- 229  80
		ROM_WORD'("01001111"),          -- 230  79
		ROM_WORD'("01001110"),          -- 231  78
		ROM_WORD'("01001110"),          -- 232  78
		ROM_WORD'("01001101"),          -- 233  77
		ROM_WORD'("01001100"),          -- 234  76
		ROM_WORD'("01001100"),          -- 235  76
		ROM_WORD'("01001011"),          -- 236  75
		ROM_WORD'("01001010"),          -- 237  74
		ROM_WORD'("01001010"),          -- 238  74
		ROM_WORD'("01001001"),          -- 239  73
		ROM_WORD'("01001001"),          -- 240  73
		ROM_WORD'("01001000"),          -- 241  72
		ROM_WORD'("01000111"),          -- 242  71
		ROM_WORD'("01000111"),          -- 243  71
		ROM_WORD'("01000110"),          -- 244  70
		ROM_WORD'("01000110"),          -- 245  70
		ROM_WORD'("01000110"),          -- 246  70
		ROM_WORD'("01000101"),          -- 247  69
		ROM_WORD'("01000101"),          -- 248  69
		ROM_WORD'("01000100"),          -- 249  68
		ROM_WORD'("01000100"),          -- 250  68
		ROM_WORD'("01000011"),          -- 251  67
		ROM_WORD'("01000011"),          -- 252  67
		ROM_WORD'("01000011"),          -- 253  67
		ROM_WORD'("01000010"),          -- 254  66
		ROM_WORD'("01000010"),          -- 255  66
		ROM_WORD'("01000010"),          -- 256  66
		ROM_WORD'("01000010"),          -- 257  66
		ROM_WORD'("01000001"),          -- 258  65
		ROM_WORD'("01000001"),          -- 259  65
		ROM_WORD'("01000001"),          -- 260  65
		ROM_WORD'("01000001"),          -- 261  65
		ROM_WORD'("01000001"),          -- 262  65
		ROM_WORD'("01000000"),          -- 263  64
		ROM_WORD'("01000000"),          -- 264  64
		ROM_WORD'("01000000"),          -- 265  64
		ROM_WORD'("01000000"),          -- 266  64
		ROM_WORD'("01000000"),          -- 267  64
		ROM_WORD'("01000000"),          -- 268  64
		ROM_WORD'("01000000"),          -- 269  64
		ROM_WORD'("01000000"),          -- 270  64
		ROM_WORD'("01000000"),          -- 271  64
		ROM_WORD'("01000000"),          -- 272  64
		ROM_WORD'("01000000"),          -- 273  64
		ROM_WORD'("01000000"),          -- 274  64
		ROM_WORD'("01000000"),          -- 275  64
		ROM_WORD'("01000000"),          -- 276  64
		ROM_WORD'("01000000"),          -- 277  64
		ROM_WORD'("01000001"),          -- 278  65
		ROM_WORD'("01000001"),          -- 279  65
		ROM_WORD'("01000001"),          -- 280  65
		ROM_WORD'("01000001"),          -- 281  65
		ROM_WORD'("01000001"),          -- 282  65
		ROM_WORD'("01000010"),          -- 283  66
		ROM_WORD'("01000010"),          -- 284  66
		ROM_WORD'("01000010"),          -- 285  66
		ROM_WORD'("01000010"),          -- 286  66
		ROM_WORD'("01000011"),          -- 287  67
		ROM_WORD'("01000011"),          -- 288  67
		ROM_WORD'("01000011"),          -- 289  67
		ROM_WORD'("01000100"),          -- 290  68
		ROM_WORD'("01000100"),          -- 291  68
		ROM_WORD'("01000101"),          -- 292  69
		ROM_WORD'("01000101"),          -- 293  69
		ROM_WORD'("01000110"),          -- 294  70
		ROM_WORD'("01000110"),          -- 295  70
		ROM_WORD'("01000110"),          -- 296  70
		ROM_WORD'("01000111"),          -- 297  71
		ROM_WORD'("01000111"),          -- 298  71
		ROM_WORD'("01001000"),          -- 299  72
		ROM_WORD'("01001001"),          -- 300  73
		ROM_WORD'("01001001"),          -- 301  73
		ROM_WORD'("01001010"),          -- 302  74
		ROM_WORD'("01001010"),          -- 303  74
		ROM_WORD'("01001011"),          -- 304  75
		ROM_WORD'("01001100"),          -- 305  76
		ROM_WORD'("01001100"),          -- 306  76
		ROM_WORD'("01001101"),          -- 307  77
		ROM_WORD'("01001110"),          -- 308  78
		ROM_WORD'("01001110"),          -- 309  78
		ROM_WORD'("01001111"),          -- 310  79
		ROM_WORD'("01010000"),          -- 311  80
		ROM_WORD'("01010000"),          -- 312  80
		ROM_WORD'("01010001"),          -- 313  81
		ROM_WORD'("01010010"),          -- 314  82
		ROM_WORD'("01010011"),          -- 315  83
		ROM_WORD'("01010100"),          -- 316  84
		ROM_WORD'("01010100"),          -- 317  84
		ROM_WORD'("01010101"),          -- 318  85
		ROM_WORD'("01010110"),          -- 319  86
		ROM_WORD'("01010111"),          -- 320  87
		ROM_WORD'("01011000"),          -- 321  88
		ROM_WORD'("01011001"),          -- 322  89
		ROM_WORD'("01011001"),          -- 323  89
		ROM_WORD'("01011010"),          -- 324  90
		ROM_WORD'("01011011"),          -- 325  91
		ROM_WORD'("01011100"),          -- 326  92
		ROM_WORD'("01011101"),          -- 327  93
		ROM_WORD'("01011110"),          -- 328  94
		ROM_WORD'("01011111"),          -- 329  95
		ROM_WORD'("01100000"),          -- 330  96
		ROM_WORD'("01100001"),          -- 331  97
		ROM_WORD'("01100010"),          -- 332  98
		ROM_WORD'("01100011"),          -- 333  99
		ROM_WORD'("01100100"),          -- 334  100
		ROM_WORD'("01100101"),          -- 335  101
		ROM_WORD'("01100110"),          -- 336  102
		ROM_WORD'("01100111"),          -- 337  103
		ROM_WORD'("01101000"),          -- 338  104
		ROM_WORD'("01101001"),          -- 339  105
		ROM_WORD'("01101010"),          -- 340  106
		ROM_WORD'("01101011"),          -- 341  107
		ROM_WORD'("01101100"),          -- 342  108
		ROM_WORD'("01101101"),          -- 343  109
		ROM_WORD'("01101110"),          -- 344  110
		ROM_WORD'("01101111"),          -- 345  111
		ROM_WORD'("01110001"),          -- 346  113
		ROM_WORD'("01110010"),          -- 347  114
		ROM_WORD'("01110011"),          -- 348  115
		ROM_WORD'("01110100"),          -- 349  116
		ROM_WORD'("01110101"),          -- 350  117
		ROM_WORD'("01110110"),          -- 351  118
		ROM_WORD'("01110111"),          -- 352  119
		ROM_WORD'("01111000"),          -- 353  120
		ROM_WORD'("01111001"),          -- 354  121
		ROM_WORD'("01111010"),          -- 355  122
		ROM_WORD'("01111100"),          -- 356  124
		ROM_WORD'("01111101"),          -- 357  125
		ROM_WORD'("01111110"),          -- 358  126
		ROM_WORD'("01111111")           -- 359  127
	);

	signal degree_0   : integer range 0 to 359;
	signal degree_60  : integer range 0 to 359;
	signal degree_120 : integer range 0 to 359;
	signal degree_180 : integer range 0 to 359;
	signal degree_240 : integer range 0 to 359;
	signal degree_300 : integer range 0 to 359;
	signal sin_0      : std_logic_vector(7 downto 0);
	signal sin_60     : std_logic_vector(7 downto 0);
	signal sin_120    : std_logic_vector(7 downto 0);
	signal sin_180    : std_logic_vector(7 downto 0);
	signal sin_240    : std_logic_vector(7 downto 0);
	signal sin_300    : std_logic_vector(7 downto 0);

begin
	process
	begin
		wait until clk_in = '1';

		if degree_0 = 359 then
			degree_0 <= 0;
		else
			degree_0 <= degree_0 + 1;
		end if;

		if degree_0 > 299 then
			degree_60 <= degree_0 - 300;
		else
			degree_60 <= degree_0 + 60;
		end if;

		if degree_0 > 239 then
			degree_120 <= degree_0 - 240;
		else
			degree_120 <= degree_0 + 120;
		end if;

		if degree_0 > 179 then
			degree_180 <= degree_0 - 180;
		else
			degree_180 <= degree_0 + 180;
		end if;

		if degree_0 > 119 then
			degree_240 <= degree_0 - 120;
		else
			degree_240 <= degree_0 + 240;
		end if;

		if degree_0 > 59 then
			degree_300 <= degree_0 - 60;
		else
			degree_300 <= degree_0 + 300;
		end if;

		sin_0   <= ROM(degree_0);       -- Read from the ROM
		sin_60  <= ROM(degree_60);      -- Read from the ROM		
		sin_120 <= ROM(degree_120);     -- Read from the ROM
		sin_180 <= ROM(degree_180);     -- Read from the ROM
		sin_240 <= ROM(degree_240);     -- Read from the ROM		
		sin_300 <= ROM(degree_300);     -- Read from the ROM

		case mode is
			when "1100" =>              --C  YAW
				sin_setpos_1 <= sin_0;
				sin_setpos_2 <= sin_180;
				sin_setpos_3 <= sin_0;
				sin_setpos_4 <= sin_180;
				sin_setpos_5 <= sin_0;
				sin_setpos_6 <= sin_180;
			when "1101" =>              --D  SURGE
				sin_setpos_1 <= X"80";
				sin_setpos_2 <= X"80";
				sin_setpos_3 <= sin_0;
				sin_setpos_4 <= sin_180;
				sin_setpos_5 <= sin_180;
				sin_setpos_6 <= sin_0;
			when "1110" =>              --E  0x10
				sin_setpos_1 <= X"10";
				sin_setpos_2 <= X"10";
				sin_setpos_3 <= X"10";
				sin_setpos_4 <= X"10";
				sin_setpos_5 <= X"10";
				sin_setpos_6 <= X"10";
			when others =>              -- (F) 
				sin_setpos_1 <= X"80";
				sin_setpos_2 <= X"80";
				sin_setpos_3 <= X"80";
				sin_setpos_4 <= X"80";
				sin_setpos_5 <= X"80";
				sin_setpos_6 <= X"80";
		end case;

	end process;
end;

  {      all available camera setting       }
  { ----------------------------------------}
  { This sampel uses the following property }
  const AeModeProp : array[ 0..16 ] of TPropList = (
    ( PropStr: 'P' ; PropID: 0 ),
    ( PropStr: 'Tv' ; PropID: 1 ),
    ( PropStr: 'Av' ; PropID: 2 ),
    ( PropStr: 'M' ; PropID: 3 ),
    ( PropStr: 'Bulb' ; PropID: 4 ),
    ( PropStr: 'A-DEP' ; PropID: 5 ),
    ( PropStr: 'DEP' ; PropID: 6 ),
    ( PropStr: 'C' ; PropID: 7 ),
    ( PropStr: 'Lock' ; PropID: 8 ),
    ( PropStr: 'Green Mode' ; PropID: 9 ),
    ( PropStr: 'Night Portrait' ; PropID: 10 ),
    ( PropStr: 'Sports' ; PropID: 11 ),
    ( PropStr: 'Portrait' ; PropID: 12 ),
    ( PropStr: 'Landscape' ; PropID: 13 ),
    ( PropStr: 'Close Up' ; PropID: 14 ),
    ( PropStr: 'Disable Strobe' ; PropID: 15 ),
    ( PropStr: 'Unknown' ; PropID: $FFFFFFFF )
  );

  const AvProp : array[ 0..53] of TPropList = (
    ( PropStr: '1.0'; PropID: $08 ), ( PropStr: '1.1'; PropID: $0B ), ( PropStr: '1.2'; PropID: $0C ),
    ( PropStr: '1.2'; PropID: $0D ), ( PropStr: '1.4'; PropID: $10 ), ( PropStr: '1.6'; PropID: $13 ),
    ( PropStr: '1.8'; PropID: $14 ), ( PropStr: '1.8'; PropID: $15 ), ( PropStr: '2.0'; PropID: $18 ),
    ( PropStr: '2.2'; PropID: $1B ), ( PropStr: '2.5'; PropID: $1C ), ( PropStr: '2.5'; PropID: $1D ),
    ( PropStr: '2.8'; PropID: $20 ), ( PropStr: '3.2'; PropID: $23 ), ( PropStr: '3.5'; PropID: $24 ),
    ( PropStr: '3.5'; PropID: $25 ), ( PropStr: '4'  ; PropID: $28 ), ( PropStr: '4';   PropID: $2B ),
    ( PropStr: '4.5'; PropID: $2C ), ( PropStr: '5'  ; PropID: $2D ), ( PropStr: '5.6'; PropID: $30 ),
    ( PropStr: '6.3'; PropID: $33 ), ( PropStr: '6.7'; PropID: $34 ), ( PropStr: '7.1'; PropID: $35 ),
    ( PropStr: '8'  ; PropID: $38 ), ( PropStr: '9'  ; PropID: $3B ), ( PropStr: '9.5'; PropID: $3C ),
    ( PropStr: '10';  PropID: $3D ), ( PropStr: '11';  PropID: $40 ), ( PropStr: '13';  PropID: $43 ),
    ( PropStr: '13';  PropID: $44 ), ( PropStr: '14';  PropID: $45 ), ( PropStr: '16';  PropID: $48 ),
    ( PropStr: '18';  PropID: $4B ), ( PropStr: '19';  PropID: $4C ), ( PropStr: '20';  PropID: $4D ),
    ( PropStr: '22';  PropID: $50 ), ( PropStr: '25';  PropID: $53 ), ( PropStr: '27';  PropID: $54 ),
    ( PropStr: '29';  PropID: $55 ), ( PropStr: '32';  PropID: $58 ), ( PropStr: '36';  PropID: $5B ),
    ( PropStr: '38';  PropID: $5C ), ( PropStr: '40';  PropID: $5D ), ( PropStr: '45';  PropID: $60 ),
    ( PropStr: '51';  PropID: $63 ), ( PropStr: '54';  PropID: $64 ), ( PropStr: '57';  PropID: $65 ),
    ( PropStr: '64';  PropID: $68 ), ( PropStr: '72';  PropID: $6B ), ( PropStr: '76';  PropID: $6C ),
    ( PropStr: '80';  PropID: $6D ), ( PropStr: '91';  PropID: $70 ), ( PropStr: 'Unknown'; PropID: $FFFFFFFF )
  );

  const TvProp : array[ 0.. 74] of TPropList = (
    ( PropStr:'Bulb'; PropID: $0C ), ( PropStr:'30"'; PropID: $10 ), ( PropStr:'25"'; PropID: $13 ),
    ( PropStr:'20"';  PropID: $14 ), ( PropStr:'20"'; PropID: $15 ), ( PropStr:'15"'; PropID: $18 ),
    ( PropStr:'13"';  PropID: $1B ), ( PropStr:'10"'; PropID: $1C ), ( PropStr:'10"'; PropID: $1D ),
    ( PropStr:' 8"';  PropID: $20 ), ( PropStr:'6"' ; PropID: $23 ), ( PropStr:'6"' ; PropID: $24 ),
    ( PropStr:'5"';   PropID: $25 ), ( PropStr:'4"' ; PropID: $28 ), ( PropStr:'3"2'; PropID: $2B ),
    ( PropStr:'3"';   PropID: $2C ), ( PropStr:'2"5'; PropID: $2D ), ( PropStr:'2"' ; PropID: $30 ),
    ( PropStr:'1"6';  PropID: $33 ), ( PropStr:'1"5'; PropID: $34 ), ( PropStr:'1"3'; PropID: $35 ),
    ( PropStr:'1"';   PropID: $38 ), ( PropStr:'0"8'; PropID: $3B ), ( PropStr:'0"7'; PropID: $3C ),
    ( PropStr:'0"6';  PropID: $3D ), ( PropStr:'0"5'; PropID: $40 ), ( PropStr:'0"4'; PropID: $43 ),
    ( PropStr:'0"3';  PropID: $44 ), ( PropStr:'0"3'; PropID: $45 ), ( PropStr:'4';   PropID: $48 ),
    ( PropStr:'5';    PropID: $4B ), ( PropStr:'6';   PropID: $4C ), ( PropStr:'6';   PropID: $4D ),
    ( PropStr:'8';    PropID: $50 ), ( PropStr:'10';  PropID: $53 ), ( PropStr:'10';  PropID: $54 ),
    ( PropStr:'13';   PropID: $55 ), ( PropStr:'15';  PropID: $58 ), ( PropStr:'20';  PropID: $5B ),
    ( PropStr:'20';   PropID: $5C ), ( PropStr:'25';  PropID: $5D ), ( PropStr:'30';  PropID: $60 ),
    ( PropStr:'40';   PropID: $63 ), ( PropStr:'45';  PropID: $64 ), ( PropStr:'50';  PropID: $65 ),
    ( PropStr:'60';   PropID: $68 ), ( PropStr:'80';  PropID: $6B ), ( PropStr:'90';  PropID: $6C ),
    ( PropStr:'100';  PropID: $6D ), ( PropStr:'125'; PropID: $70 ), ( PropStr:'160'; PropID: $73 ),
    ( PropStr:'180';  PropID: $74 ), ( PropStr:'200'; PropID: $75 ), ( PropStr:'250'; PropID: $78 ),
    ( PropStr:'320';  PropID: $7B ), ( PropStr:'350'; PropID: $7C ), ( PropStr:'400'; PropID: $7D ),
    ( PropStr:'500';  PropID: $80 ), ( PropStr:'640'; PropID: $83 ), ( PropStr:'750'; PropID: $84 ),
    ( PropStr:'800';  PropID: $85 ), ( PropStr:'1000';PropID: $88 ), ( PropStr:'1250';PropID: $8B ),
    ( PropStr:'1500'; PropID: $8C ), ( PropStr:'1600';PropID: $8D ), ( PropStr:'2000';PropID: $90 ),
    ( PropStr:'2500'; PropID: $93 ), ( PropStr:'3000';PropID: $94 ), ( PropStr:'3200';PropID: $95 ),
    ( PropStr:'4000'; PropID: $98 ), ( PropStr:'5000';PropID: $9B ), ( PropStr:'6000';PropID: $9C ),
    ( PropStr:'6400'; PropID: $9D ), ( PropStr:'8000';PropID: $A0 ), ( PropStr:'Unknown'; PropID: $FFFFFFFF )
  );

  const IsoProp : array[0..19 ] of TPropList = (
    ( PropStr: '6'   ; PropID: $28 ),
    ( PropStr: '12'  ; PropID: $30 ),
    ( PropStr: '25'  ; PropID: $38 ),
    ( PropStr: '50'  ; PropID: $40 ),
    ( PropStr: '100' ; PropID: $48 ),
    ( PropStr: '125' ; PropID: $4B ),
    ( PropStr: '160' ; PropID: $4D ),
    ( PropStr: '200' ; PropID: $50 ),
    ( PropStr: '250' ; PropID: $53 ),
    ( PropStr: '320' ; PropID: $55 ),
    ( PropStr: '400' ; PropID: $58 ),
    ( PropStr: '500' ; PropID: $5B ),
    ( PropStr: '640' ; PropID: $5D ),
    ( PropStr: '800' ; PropID: $60 ),
    ( PropStr: '1000' ; PropID: $63 ),
    ( PropStr: '1250' ; PropID: $65 ),
    ( PropStr: '1600' ; PropID: $68 ),
    ( PropStr: '3200' ; PropID: $70 ),
    ( PropStr: '6400' ; PropID: $78 ),
    ( PropStr: 'Unknown' ; PropID: $FFFFFFFF )
  );

  const ImageTypeProp : array[0..4 ] of TPropList = (
    ( PropStr: 'UnKnown'    ; PropID: 0 ),
    ( PropStr: 'Jpeg'       ; PropID: 1 ),
    ( PropStr: 'CRW'        ; PropID: 2 ),
    ( PropStr: 'RAW'        ; PropID: 4 ),
    ( PropStr: 'CR2'        ; PropID: 6 )
  );

  const ImageSizeProp : array[0..5 ] of TPropList = (
    ( PropStr: 'Large'    ; PropID: 0 ),
    ( PropStr: 'Middle'   ; PropID: 1 ),
    ( PropStr: 'Small'    ; PropID: 2 ),
    ( PropStr: 'Middle1'  ; PropID: 5 ),
    ( PropStr: 'Middle2'  ; PropID: 6 ),
    ( PropStr: 'UnKnown'  ; PropID: $FFFFFFFF )
  );

  const ImageQualityProp : array[0..4 ] of TPropList = (
    ( PropStr: 'Normal'   ; PropID: 2 ),
    ( PropStr: 'Fine'     ; PropID: 3 ),
    ( PropStr: 'Lossless' ; PropID: 4 ),
    ( PropStr: 'SuperFine'; PropID: 5 ),
    ( PropStr: 'UnKnown'  ; PropID: $FFFFFFFF )
  );

  // White ballance
  const WBProp : array[0..12 ] of TPropList = (
    ( PropStr: 'Auto'       ; PropID: 0 ),
    ( PropStr: 'Daylight'   ; PropID: 1 ),
    ( PropStr: 'Cloudy'     ; PropID: 2 ),
    ( PropStr: 'Tangsten'   ; PropID: 3 ),
    ( PropStr: 'Fluorescent'; PropID: 4 ),
    ( PropStr: 'Strobe'     ; PropID: 5 ),
    ( PropStr: 'WhitePaper' ; PropID: 6 ),
    ( PropStr: 'Shade'      ; PropID: 7 ),
    ( PropStr: 'ColorTemp'  ; PropID: 8 ),
    ( PropStr: 'PCSet1'     ; PropID: 9 ),
    ( PropStr: 'PCSet2'     ; PropID: 10 ),
    ( PropStr: 'PCSet3'     ; PropID: 11 ),
    ( PropStr: 'Pasted'     ; PropID: 12 )
  );

  // Image quality in the menu Quality
  const QualityProp : array[0..7 ] of TPropList = (
    ( PropStr: 'hL'         ; PropID: $00130F0F ),
    ( PropStr: 'lL'         ; PropID: $00120F0F ),
    ( PropStr: 'hM'         ; PropID: $01130F0F ),
    ( PropStr: 'lM'         ; PropID: $01120F0F ),
    ( PropStr: 'hS'         ; PropID: $02130F0F ),
    ( PropStr: 'lS'         ; PropID: $02120F0F ),
    ( PropStr: 'RAW+L'      ; PropID: $00640013 ),
    ( PropStr: 'RAW'        ; PropID: $00640F0F )
  );


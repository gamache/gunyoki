require 'test_helper'

class GameTest < ActiveSupport::TestCase

  XLOGFILE_CHUNK = <<-EOT
7-0 version=3.4.3:points=98:deathdnum=0:deathlev=1:maxlvl=1:hp=-6:maxhp=13:deaths=1:deathdate=20101030:birthdate=20101030:uid=5062:role=Hea:race=Hum:gender=Mal:align=Neu:name=salieri:death=killed by an air elemental of Hermes, while helpless:conduct=0xff7:turns=57:achieve=0x0:realtime=114:starttime=1288498586:endtime=1288504314:gender0=Mal:align0=Neu:extinctions=0:kills120=0
7-1 version=3.4.3:points=176:deathdnum=0:deathlev=3:maxlvl=3:hp=-8:maxhp=18:deaths=1:deathdate=20101030:birthdate=20101030:uid=5062:role=Val:race=Dwa:gender=Fem:align=Law:name=salieri:death=killed by a wand:conduct=0xfcf:turns=218:achieve=0x0:realtime=113:starttime=1288508048:endtime=1288508164:gender0=Fem:align0=Law:extinctions=0:kills120=6
7-2 version=3.4.3:points=3:deathdnum=0:deathlev=1:maxlvl=1:hp=11:maxhp=11:deaths=0:deathdate=20101031:birthdate=20101031:uid=5062:role=Wiz:race=Elf:gender=Mal:align=Cha:name=salieri:death=escaped:conduct=0xfff:turns=1:achieve=0x0:realtime=3:starttime=1288508651:endtime=1288508657:gender0=Mal:align0=Cha:extinctions=0:kills120=0
7-3 version=3.4.3:points=50:deathdnum=0:deathlev=2:maxlvl=2:hp=-8:maxhp=14:deaths=1:deathdate=20101031:birthdate=20101031:uid=5062:role=Pri:race=Hum:gender=Fem:align=Cha:name=salieri:death=killed by a wand:conduct=0xfff:turns=120:achieve=0x0:realtime=89:starttime=1288508740:endtime=1288508840:gender0=Fem:align0=Cha:extinctions=0:kills120=3
16-0 version=3.4.3:points=55:deathdnum=0:deathlev=1:maxlvl=1:hp=0:maxhp=12:deaths=1:deathdate=20101101:birthdate=20101101:uid=5048:role=Wiz:race=Hum:gender=Mal:align=Neu:name=kerio:death=killed by a kobold:conduct=0xfff:turns=45:achieve=0x0:realtime=20:starttime=1288594628:endtime=1288594649:gender0=Mal:align0=Neu:extinctions=0:kills120=0
6-0 version=3.4.3:points=3:deathdnum=0:deathlev=1:maxlvl=1:hp=11:maxhp=11:deaths=0:deathdate=20101101:birthdate=20101101:uid=5100:role=Wiz:race=Elf:gender=Fem:align=Cha:name=behiker57w:death=escaped:conduct=0xfff:turns=1:achieve=0x0:realtime=12:starttime=1288595458:endtime=1288595476:gender0=Fem:align0=Cha:extinctions=0:kills120=0
6-1 version=3.4.3:points=2:deathdnum=0:deathlev=1:maxlvl=1:hp=11:maxhp=11:deaths=0:deathdate=20101101:birthdate=20101101:uid=5100:role=Wiz:race=Elf:gender=Fem:align=Cha:name=behiker57w:death=escaped:conduct=0xfff:turns=1:achieve=0x0:realtime=3:starttime=1288595496:endtime=1288595505:gender0=Fem:align0=Cha:extinctions=0:kills120=0
6-2 version=3.4.3:points=17:deathdnum=0:deathlev=1:maxlvl=1:hp=0:maxhp=11:deaths=1:deathdate=20101101:birthdate=20101101:uid=5100:role=Wiz:race=Elf:gender=Fem:align=Cha:name=behiker57w:death=killed by a kobold zombie, while helpless:conduct=0xfb7:turns=55:achieve=0x0:realtime=97:starttime=1288595527:endtime=1288595631:gender0=Fem:align0=Cha:extinctions=0:kills120=0
16-1 version=3.4.3:points=68:deathdnum=0:deathlev=1:maxlvl=1:hp=0:maxhp=12:deaths=1:deathdate=20101101:birthdate=20101101:uid=5048:role=Wiz:race=Hum:gender=Mal:align=Neu:name=kerio:death=killed by a fox:conduct=0xf8f:turns=173:achieve=0x0:realtime=138:starttime=1288594688:endtime=1288595617:gender0=Mal:align0=Neu:extinctions=0:kills120=2
6-3 version=3.4.3:points=0:deathdnum=0:deathlev=1:maxlvl=1:hp=0:maxhp=15:deaths=1:deathdate=20101101:birthdate=20101101:uid=5027:role=Sam:race=Hum:gender=Mal:align=Law:name=ellone:death=killed by a water demon:conduct=0xfff:turns=12:achieve=0x0:realtime=25:starttime=1288596642:endtime=1288596672:gender0=Mal:align0=Law:extinctions=0:kills120=0
  EOT

  XLOGFILE_LINES = XLOGFILE_CHUNK.split(/\n\s*/)

  test 'Game.from_xlogfile_line' do
    XLOGFILE_LINES.each do |line|
      verify_game(Game.from_xlogfile_line(line))
    end
  end

  test 'Game.from_xlogfile_hash' do

  end

private

  def verify_game(g)
    assert g
    assert_instance_of Game, g
    fields = g.attributes.keys - %w( id created_at updated_at player_id tournament_id )
    fields.each do |field|
      assert g.send(field)
    end
  end

end

abstract class LogicEvent {}

class InitEvent extends LogicEvent {}

class GetLanguage extends LogicEvent {
  String selectedlanguage;

  GetLanguage(this.selectedlanguage);
}

class Eye extends LogicEvent {
  bool eye;

  Eye(this.eye);
}

class GetGender extends LogicEvent {
  String gen;

  GetGender(this.gen);
}

class GetCategory extends LogicEvent {
  String cat;

  GetCategory(this.cat);
}

class Downloading extends LogicEvent {
  bool d_val, download;

  Downloading(this.d_val, this.download);
}

class CardCbx extends LogicEvent {
  bool val;

  CardCbx(this.val);
}

class CoupanRadio extends LogicEvent {
  String cpradio;
  double discount;

  CoupanRadio(this.cpradio, this.discount);
}



class Country extends LogicEvent {
  String cntry;

  Country(this.cntry);
}

class Date extends LogicEvent {
  String date;

  Date(this.date);
}

class ShowMore extends LogicEvent {
  bool show;

  ShowMore(this.show);
}

class LastView extends LogicEvent {
  String cfi;

  LastView(this.cfi);
}

class TakeImage extends LogicEvent {
  String image;

  TakeImage(this.image);
}

class UserName extends LogicEvent {
  String name;

  UserName(this.name);
}

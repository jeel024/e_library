
import 'dart:io';

import 'package:bloc/bloc.dart';


import '../../config/contants/snackbar.dart';
import 'logic_event.dart';
import 'logic_state.dart';

class LogicBloc extends Bloc<LogicEvent, LogicState> {
  LogicBloc() : super(LogicInitial()) {

    on<GetLanguage>(_getLanguage);
    on<Eye>(_geteye);
    //on<GetGender>(_getGender);
    on<GetCategory>(_getCategory);
    on<CardCbx>(_cardcbx);
    on<CoupanRadio>(_coupanradio);
    on<Country>(_country);
    on<Date>(_date);
    on<ShowMore>(_show);
    on<LastView>(_lastview);
   // on<TakeImage>(_takeImage);
    on<UserName>(_name);

  }


  String name = '';
  File? path ;

  String? language = '';

  _getLanguage(GetLanguage event, Emitter<LogicState> emit) {
    try {
      emit(LogicLoading());
      language = event.selectedlanguage;
      emit(LogicLoaded());
    } catch (e) {
      errorSnackbar(e.toString());
      emit(LogicError());
    }
  }

  bool eye = false;

  _geteye(Eye event, Emitter<LogicState> emit) {
    try {
      emit(LogicLoading());
      eye = !event.eye;
      emit(LogicLoaded());
    } catch (e) {
      errorSnackbar(e.toString());
      emit(LogicError());
    }
  }

  //String gen = '';

  // _getGender(GetGender event, Emitter<LogicState> emit) {
  //   try {
  //     emit(LogicLoading());
  //     gen = event.gen;
  //     emit(LogicLoaded());
  //   } catch (e) {
  //     errorSnackbar(e.toString());
  //     emit(LogicError());
  //   }
  // }

  List<String> get_ctgr = [];

  _getCategory(GetCategory event, Emitter<LogicState> emit) {
    try {
      emit(LogicLoading());
      if(get_ctgr.contains(event.cat))
        {
          get_ctgr.remove(event.cat);
        }
      else
        {
          get_ctgr.add(event.cat);
        }

      emit(LogicLoaded());
    } catch (e) {
      errorSnackbar(e.toString());
      emit(LogicError());
    }
  }





    bool value = false;
   _cardcbx(CardCbx event, Emitter<LogicState> emit) {
     try
     {
           emit(LogicLoading());
           value = event.val;
           emit(LogicLoaded());

     }
     catch(e)
     {
       errorSnackbar("couldn't save information");
       emit(LogicError());
     }
  }

    String cpradio = '';
   double discount = 0.0;
   _coupanradio(CoupanRadio event, Emitter<LogicState> emit) {
     try
     {
       emit(LogicLoading());
       cpradio  = event.cpradio;
       discount = event.discount;
       emit(LogicLoaded());
     }
     catch(e)
     {
       errorSnackbar("");
       emit(LogicError());
     }
  }

  String cntry = '';
   _country(Country event, Emitter<LogicState> emit) {
     try
     {
       emit(LogicLoading());
       cntry = event.cntry;
       emit(LogicLoaded());
     }
     catch(e)
     {
       errorSnackbar("");
       emit(LogicError());
     }
  }
  String date = '';
   _date(Date event, Emitter<LogicState> emit)
   {
     try
     {
       emit(LogicLoading());
       date = event.date;
       emit(LogicLoaded());
     }
     catch(e)
     {
       errorSnackbar("");
       emit(LogicError());

     }
   }

   bool show = false;
   _show(ShowMore event, Emitter<LogicState> emit) {
     try
     {
       emit(LogicLoading());
       show = event.show;
       emit(LogicLoaded());
     }
     catch(e)
     {
       errorSnackbar("");
       emit(LogicError());

     }
  }
    String cfi = '';
   _lastview(LastView event, Emitter<LogicState> emit) {
     try
     {
       emit(LogicLoading());
       cfi = event.cfi;
       emit(LogicLoaded());
     }
     catch(e)
     {
       errorSnackbar("Can't Open book");
       emit(LogicError());

     }
  }
  // String img = '';
  //  _takeImage(TakeImage event, Emitter<LogicState> emit) {
  //    try
  //    {
  //      emit(LogicLoading());
  //      img = event.image;
  //      emit(LogicLoaded());
  //    }
  //    catch(e)
  //    {
  //      errorSnackbar("Can't take image");
  //      emit(LogicError());
  //    }
  // }



   _name(UserName event, Emitter<LogicState> emit) {
     try {
       emit(LogicLoading());

       name = event.name;
       emit(LogicLoaded());
     }
     catch (e) {
       errorSnackbar("Can't take image");
       emit(LogicError());
     }
   }


}

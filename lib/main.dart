import 'dart:core';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';

import 'data.dart';

const historyBoxName = 'historyBoxName';
const themeBoxName = 'themeBoxName';

const Color colorDark = Color(0xFF374352);
const Color colorLight = Color(0xFFe6eeff);

const Color primaryColor = colorDark;
const Color primaryContainer = colorDark;
const secondaryTextColor = Color(0xffAFBED0);
const primaryTextColor = Color(0xff1D2830);

Future<void> main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(HistoryAdapter());
  Hive.registerAdapter(ThemeLightNightAdapter());
  await Hive.openBox<History>(historyBoxName);
  await Hive.openBox<ThemeLightNight>(themeBoxName);

  try {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: primaryContainer));
  } catch (e) {}

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pro Calculator',
      home: const CalculatorProApp(),
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
          primary: primaryColor,
          onPrimary: Colors.white,
          secondary: primaryColor,
          onSecondary: Colors.white,
          primaryContainer: primaryContainer,
          background: Color(0xffF3F5F8),
          onBackground: primaryTextColor,
          onSurface: primaryTextColor,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          labelStyle: TextStyle(color: secondaryTextColor),
          iconColor: secondaryTextColor,
          border: InputBorder.none,
        ),
        // textTheme: GoogleFonts.poppinsTextTheme(const TextTheme(
        //     headlineSmall: TextStyle(fontWeight: FontWeight.w500))
        // ),
      ),
    );
  }
}

class CalculatorProApp extends StatefulWidget {
  const CalculatorProApp({super.key});

  @override
  _CalculatorProAppState createState() => _CalculatorProAppState();
}

class _CalculatorProAppState extends State<CalculatorProApp> {
  bool darkMode = true;
  final Box<ThemeLightNight> boxThemeLightNight =
      Hive.box<ThemeLightNight>(themeBoxName);
  final ThemeLightNight themeLightNight = ThemeLightNight();
  final Box<History> boxHistory = Hive.box<History>(historyBoxName);

  void makeThemeLightNight() {
    themeLightNight.darkMode = true;
    if (boxThemeLightNight.values.isEmpty) {
      boxThemeLightNight.add(themeLightNight);
      darkMode = themeLightNight.darkMode;
    } else {
      darkMode = boxThemeLightNight.values.first.darkMode;
    }
  }

  void saveHistory() {
    History history = History();
    history.calculate = firstNumber +
        " " +
        selectedOperator +
        " " +
        secondNumber +
        " = " +
        showResultTextView;
    history.time = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());
    boxHistory.add(history);
  }

  void shareResult() {
    String temp = firstNumber +
        " " +
        selectedOperator +
        " " +
        secondNumber +
        " = " +
        showResultTextView;
    Share.share('$temp', subject: 'Calculate');
  }

  int _counter = 0;

  //{
  double resultNumber = 0;
  String selectedOperator = "";
  bool userChoseOperator = false;
  String firstNumber = "";
  String secondNumber = "";
  bool clearAfterCalculateResul = false;
  String showNumbersTextView = "0";
  String showResultTextView = "";
  String showHistoryTextView = "";

  //}
  void clearAll() {
    resultNumber = 0;
    selectedOperator = "";
    firstNumber = "";
    secondNumber = "";
    userChoseOperator = false;
    clearAfterCalculateResul = false;
    showNumbersTextView = "0";
    showResultTextView = "";
  }

  void onClickClearButtonEvent() {
    checkForClearDisplay();
    if (secondNumber.isEmpty) {
      if (userChoseOperator) {
        userChoseOperator = false;
        selectedOperator = "";
      } else {
        if ((firstNumber.isNotEmpty)) {
          firstNumber =
              (firstNumber.substring(0, (firstNumber.length - 1))).toString();
        }
      }
    } else {
      secondNumber =
          (secondNumber.substring(0, (secondNumber.length - 1))).toString();
    }
    displayShowNumbers();
  }

  void checkForClearDisplay() {
    if (clearAfterCalculateResul) {
      clearAll();
      clearAfterCalculateResul = false;
    }
  }

  void displayShowError(String error) {
    showResultTextView = error;
  }

  void displayShowResult(String result) {
    // String textOne = ((((firstNumber)))) + " ";
    // var hasNewLine = " ";
    // if (resources.configuration.orientation == Configuration.ORIENTATION_PORTRAIT) {
    // hasNewLine = "\n"
    // }
    // String textTwo = textOne + selectedOperator + " " + ((((secondNumber)))); // + hasNewLine
    // String textAll = textTwo + "\n" + "= " + (((deleteDotAndZeroInLastNumber(result))));

    String textAll = (((deleteDotAndZeroInLastNumber(result))));

    //change the Text Color of a Substring in android using SpannableString class
    //https://www.geeksforgeeks.org/how-to-change-the-text-color-of-a-substring-in-android-using-spannablestring-class/
    // val spannableString = SpannableString(textAll)
    // It is used to set foreground color.
    //val green = ForegroundColorSpan(resources.getColor(R.color.ic_launcher_background))
    // if use same color spannable color do not work. change litle 2 digit color and spannable good work and paint the colored operator
    //val ic_launcher_background_result_equal =
    //ForegroundColorSpan(resources.getColor(R.color.ic_launcher_background_result_equal))
    // val yellow = BackgroundColorSpan(Color.YELLOW)
    // It is used to set the span to the string
    //spannableString.setSpan(
    // green,
    // textOne.length, (textOne.length + 1), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
    // )
    // It is used to set the span to the string
    //spannableString.setSpan(
    // ic_launcher_background_result_equal,
    // (textTwo.length), ((textTwo.length) + 1), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
    // )

    //binding.showresulttextview.setText(spannableString, TextView.BufferType.SPANNABLE);
    showResultTextView = textAll;
    showHistoryTextView += firstNumber +
        " " +
        selectedOperator +
        " " +
        secondNumber +
        " = " +
        showResultTextView +
        "  ,   ";
  }

  void displayShowNumbers() {
    String textOne = ((((firstNumber)))) + " ";
    String text = textOne + selectedOperator + " " + ((((secondNumber))));
    //val spannableString = SpannableString(text)
    // It is used to set foreground color.
    //val green = ForegroundColorSpan(resources.getColor(R.color.ic_launcher_background))

    // It is used to set the span to the string
    //spannableString.setSpan(
    //  green,
    //  textOne.length, (textOne.length + 1), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE
    //)
    // binding.showresulttextview.setText(spannableString, TextView.BufferType.SPANNABLE);
    showNumbersTextView = text;
  }

  void onClickOperationEvent(String operator) {
    if (firstNumber.isNotEmpty) {
      if (selectedOperator.isEmpty) {
        {
          // select operator
          setSelectedOperator(operator);
          userChoseOperator = true;
          checkForHaveGoodDigit();
          displayShowNumbers();
        }
      } else {
        if ((secondNumber.isNotEmpty)) {
          //  if ("text".contains("=")) {
          if (clearAfterCalculateResul) {
            String tempFirstNumber =
                deleteDotAndZeroInLastNumber(resultNumber.toString());
            //tempFirstNumber = removeDoteZeros(tempFirstNumber.toString());
            clearAll();
            firstNumber = tempFirstNumber;
            setSelectedOperator(operator);
            userChoseOperator = true;
            checkForHaveGoodDigit();
            displayShowNumbers();
          } else {
            calculate();
          }
        } else {
          {
            // change operator
            setSelectedOperator(operator);
            userChoseOperator = true;
            checkForHaveGoodDigit();
            displayShowNumbers();
          }
        }
      }
    }
  }

  void setSelectedOperator(String operator) {
    switch (operator) {
      case "÷":
        {
          selectedOperator = "÷";
        }
        break;

      case "×":
        {
          selectedOperator = "×";
        }
        break;
      case "-":
        {
          selectedOperator = "-";
        }
        break;
      case "+":
        {
          selectedOperator = "+";
        }
        break;
    }
  }

  String deleteDotAndZeroInLastNumber(String number) {
    String tempNumber = number;
    if (tempNumber.isNotEmpty) {
      if (tempNumber.contains(".")) {
        if (tempNumber.endsWith(".0")) {
          tempNumber = tempNumber.substring(0, (tempNumber.length - 2));
        }
      }
    }
    return tempNumber;
  }

  void checkForHaveGoodDigit() {
    if (firstNumber.isNotEmpty) {
      if (firstNumber.contains(".")) {
        if (firstNumber.endsWith(".")) {
          firstNumber = firstNumber.substring(0, (firstNumber.length - 1));
        }
      }
    }
    if (secondNumber.isNotEmpty) {
      if (secondNumber.contains(".")) {
        if (secondNumber.endsWith(".")) {
          secondNumber = secondNumber.substring(0, (secondNumber.length - 1));
        }
      }
    }
  }

  String calculateNextCharacter(String oldNumber, String newNumber) {
    var number = oldNumber;
    switch (newNumber) {
      case "0":
        {
          if (number == "0" || number == "") {
            number = "0";
          } else {
            number += "0";
          }
        }
        break;

      case "1":
        {
          if (number == "0" || number == "") {
            number = "1";
          } else {
            number += "1";
          }
        }
        break;
      case "2":
        {
          if (number == "0" || number == "") {
            number = "2";
          } else {
            number += "2";
          }
        }
        break;
      case "3":
        {
          if (number == "0" || number == "") {
            number = "3";
          } else {
            number += "3";
          }
        }
        break;
      case "4":
        {
          if (number == "0" || number == "") {
            number = "4";
          } else {
            number += "4";
          }
        }
        break;
      case "5":
        {
          if (number == "0" || number == "") {
            number = "5";
          } else {
            number += "5";
          }
        }
        break;
      case "6":
        {
          if (number == "0" || number == "") {
            number = "6";
          } else {
            number += "6";
          }
        }
        break;
      case "7":
        {
          if (number == "0" || number == "") {
            number = "7";
          } else {
            number += "7";
          }
        }
        break;
      case "8":
        {
          if (number == "0" || number == "") {
            number = "8";
          } else {
            number += "8";
          }
        }
        break;
      case "9":
        {
          if (number == "0" || number == "") {
            number = "9";
          } else {
            number += "9";
          }
        }
        break;
      case ".":
        {
          if (!(number.contains("."))) {
            if (number == "") {
              number = "0" + ".";
            } else {
              number += ".";
            }
          }
        }
        break;
      case "±":
        {
          if (number == "0" || number == "") {
            number = "0";
          } else {
            if (number.startsWith("-")) {
              try {
                number = number.substring(1, (number.length));
              } catch (e) {
                number = "0";
              }
            } else {
              number = "-" + number;
            }
          }
        }
        break;
      case "%":
        {
          if (number == "0" || number == "") {
            number = "0";
          } else {
            number = (((double.parse(number)) * 0.01)).toString();
          }
        }
        break;
      case "^":
        {
          if (number == "0" || number == "") {
            number = "0";
          } else {
            number =
                ((double.parse(number)) * (double.parse(number))).toString();
          }
        }
        break;
      case "sin":
        {
          if (number == "0" || number == "") {
            number = "0";
          } else {
            //https://www.educative.io/answers/what-is-sin-in-dart
            //converting the degrees angle into radians and then applying sin()
            // degrees = 90.0
            // PI = 3.14159265
            // result first converts degrees to radians then apply sin
            number = (num.parse(number)).isFinite
                ? (sin((num.parse(number) * (pi / 180.0)))).toString()
                : "0";
          }
        }
        break;
    }
    return number;
  }

  void onClickEqualButtonEvent() {
    calculate();
  }

  void calculate() {
    // checkForClearDisplay();
    try {
      if (userChoseOperator &&
          firstNumber.isNotEmpty &&
          secondNumber.isNotEmpty) {
        clearAfterCalculateResul = true;
        userChoseOperator = false;
        checkForHaveGoodDigit();
        switch (selectedOperator) {
          case "×":
            {
              //resultNumber = (firstNumber.toDouble()) * (secondNumber.toDouble());
              resultNumber =
                  ((double.parse(firstNumber))) * (double.parse(secondNumber));
            }
            break;
          case "+":
            {
              resultNumber =
                  (double.parse(firstNumber)) + (double.parse(secondNumber));
            }
            break;
          case "÷":
            {
              resultNumber =
                  (double.parse(firstNumber)) / (double.parse(secondNumber));
            }
            break;
          case "-":
            {
              resultNumber =
                  (double.parse(firstNumber)) - (double.parse(secondNumber));
            }
            break;
        }
        displayShowResult(resultNumber.toString());
      }
    } catch (e) {
      displayShowError("Error ... Please report it to Developer.$e");
    }
    try {
      saveHistory();
      scroll();
    } catch (e, s) {
     // print(s);
    }

  }

  void onClickButtonEvent(String number) {
    checkForClearDisplay();
    if (userChoseOperator) {
      secondNumber = calculateNextCharacter(secondNumber, number);
    } else {
      firstNumber = calculateNextCharacter(firstNumber, number);
    }
    displayShowNumbers();
  }

  void _incrementCounter(int number) {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      // _counter++;
      _counter += number;
    });
  }

  final ScrollController _scrollController = ScrollController();

  void scroll() {
    try {
      _scrollController.animateTo(
          //_scrollController.position.maxScrollExtent,
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          // curve: Curves.easeInOut
          curve: Curves.fastOutSlowIn);
    } catch (e) {
      displayShowError("Error ... Please report it to Developer.$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    makeThemeLightNight();
    const double fontSize = 38;
    return Scaffold(
      backgroundColor: darkMode ? colorDark : colorLight,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //+++++++++++++++++++++++++Display++++++++++++++++++++++++++++++++
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // GestureDetector(
                    //     onTap: (){
                    //       setState(() {
                    //         darkMode? darkMode=false:darkMode=true;
                    //       });
                    //     },
                    //     child: _switchMode()),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      // Icon(CupertinoIcons.restart,
                      //     color: darkMode
                      //         ? Colors.green
                      //         : Colors.redAccent),
                      Expanded(
                        //contains a single child which is scrollable
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          physics: const BouncingScrollPhysics(),
                          //for horizontal scrolling
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            '$showHistoryTextView',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.normal,
                                color: darkMode ? Colors.white : Colors.black),
                          ),
                        ),
                      ),
                    ]),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Expanded(
                        //contains a single child which is scrollable
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          //for horizontal scrolling
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            '$firstNumber',
                            style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                color: darkMode ? Colors.white : Colors.black),
                          ),
                        ),
                      ),
                    ]),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      const SizedBox(
                        width: 24,
                      ),
                      selectedOperator.isNotEmpty
                          ? Text(
                              '$selectedOperator',
                              style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.w400,
                                  color: darkMode
                                      ? Colors.green
                                      : Colors.redAccent),
                            )
                          : const SizedBox(),
                    ]),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Expanded(
                        //contains a single child which is scrollable
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          //for horizontal scrolling
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            '$secondNumber',
                            style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                color: darkMode ? Colors.white : Colors.black),
                          ),
                        ),
                      ),
                    ]),
                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      const SizedBox(
                        width: 24,
                      ),
                      showResultTextView.isNotEmpty
                          ? Text(
                              '=',
                              style: TextStyle(
                                  fontSize: fontSize,
                                  fontWeight: FontWeight.w400,
                                  color: darkMode
                                      ? Colors.green
                                      : Colors.redAccent),
                            )
                          : const SizedBox(),
                    ]),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Expanded(
                        //contains a single child which is scrollable
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          //for horizontal scrolling
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            '$showResultTextView',
                            style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                color: darkMode ? Colors.white : Colors.black),
                          ),
                        ),
                      ),
                    ]),
                    // const SizedBox(
                    //   height: 10,
                    // )
                  ],
                ),
              ),
              //+++++++++++++++++++++end+Display++++++++++++++++++++++++++++++++
              Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                darkMode = darkMode
                                    ? darkMode = false
                                    : darkMode = true;
                                //_incrementCounter(4);
                                if (boxThemeLightNight.values.isEmpty) {
                                  themeLightNight.darkMode = darkMode;
                                  boxThemeLightNight.add(themeLightNight);
                                } else {
                                  boxThemeLightNight.values.first.darkMode =
                                      darkMode;
                                  boxThemeLightNight.values.first.save();
                                }
                              });
                            },
                            child: _switchModeSmall()),
                        //_switchMode(),
                        // GestureDetector(
                        //     onTap: () {
                        //       setState(() {});
                        //     },
                        //     child: _buttonOval(title: 'sin')),
                        GestureDetector(
                            onTap: () {
                              setState(() {});
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => HistoryScreen()));
                            },
                            child: _buttonOvalIcon(title: 'history')),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                onClickButtonEvent("sin");
                              });
                            },
                            child: _buttonOval(title: 'sin')),
                        //_buttonOval(title: 'tan'),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                onClickButtonEvent("^");
                              });
                            },
                            child: _buttonOval(title: '^'))
                      ]),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            shareResult();
                          },
                          child: _buttonRounded(
                              icon: CupertinoIcons.share,
                              iconColor:
                                  darkMode ? Colors.green : Colors.redAccent)),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              onClickButtonEvent("±");
                            });
                          },
                          child: _buttonRounded(
                              icon: CupertinoIcons.plusminus,
                              iconColor:
                                  darkMode ? Colors.white : Colors.black)),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              onClickButtonEvent("%");
                            });
                          },
                          child: _buttonRounded(
                              icon: CupertinoIcons.percent,
                              iconColor:
                                  darkMode ? Colors.white : Colors.black)),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              onClickOperationEvent("÷");
                            });
                          },
                          child: _buttonRounded(
                              icon: CupertinoIcons.divide,
                              iconColor:
                                  darkMode ? Colors.green : Colors.redAccent)),
                      // _buttonRounded(
                      //     title: '÷',
                      //     textColor:
                      //         darkMode ? Colors.green : Colors.redAccent),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              onClickButtonEvent("7");
                            });
                          },
                          child: _buttonRounded(title: '7')),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              onClickButtonEvent("8");
                            });
                          },
                          child: _buttonRounded(title: '8')),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              _counter = 0;
                              onClickButtonEvent("9");
                            });
                          },
                          child: _buttonRounded(title: '9')),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              onClickOperationEvent("×");
                            });
                          },
                          child: _buttonRounded(
                              icon: CupertinoIcons.multiply,
                              iconColor:
                                  darkMode ? Colors.green : Colors.redAccent)),
                      // _buttonRounded(
                      //     title: '×',
                      //     textColor:
                      //         darkMode ? Colors.green : Colors.redAccent),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              onClickButtonEvent("4");
                            });
                          },
                          child: _buttonRounded(title: '4')),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              onClickButtonEvent("5");
                            });
                          },
                          child: _buttonRounded(title: '5')),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              onClickButtonEvent("6");
                            });
                          },
                          child: _buttonRounded(title: '6')),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              onClickOperationEvent("-");
                            });
                          },
                          child: _buttonRounded(
                              icon: CupertinoIcons.minus,
                              iconColor:
                                  darkMode ? Colors.green : Colors.redAccent)),
                      // _buttonRounded(
                      //     title: '-',
                      //     textColor:
                      //         darkMode ? Colors.green : Colors.redAccent),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              onClickButtonEvent("1");
                            });
                          },
                          child: _buttonRounded(title: '1')),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              onClickButtonEvent("2");
                            });
                          },
                          child: _buttonRounded(title: '2')),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              onClickButtonEvent("3");
                            });
                          },
                          child: _buttonRounded(title: '3')),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              onClickOperationEvent("+");
                            });
                          },
                          child: _buttonRounded(
                              icon: CupertinoIcons.plus,
                              iconColor:
                                  darkMode ? Colors.green : Colors.redAccent)),
                      // _buttonRounded(
                      //     title: '+',
                      //     textColor:
                      //         darkMode ? Colors.green : Colors.redAccent),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onLongPress: () {
                            setState(() {
                              clearAll();
                            });
                          },
                          onTap: () {
                            setState(() {
                              onClickClearButtonEvent();
                            });
                          },
                          child: _buttonRounded(
                              icon: CupertinoIcons.back,
                              iconColor:
                                  darkMode ? Colors.green : Colors.redAccent)),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              onClickButtonEvent("0");
                            });
                          },
                          child: _buttonRounded(title: '0')),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              onClickButtonEvent(".");
                            });
                          },
                          child: _buttonRounded(title: '.')),
                      GestureDetector(
                          onTap: () {
                            setState(() {
                              onClickEqualButtonEvent();
                            });
                          },
                          child: _buttonRounded(
                              icon: CupertinoIcons.equal,
                              iconColor:
                                  darkMode ? Colors.green : Colors.redAccent)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buttonRounded(
      {String? title,
      Color? textColor,
      double padding = 16,
      IconData? icon,
      Color? iconColor}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ProContainer(
        darkMode: darkMode,
        borderRadius: BorderRadius.circular(40),
        padding: EdgeInsets.all(padding),
        child: Container(
          width: padding * 2,
          height: padding * 2,
          child: Center(
            child: title != null
                ? Text(
                    title,
                    style: TextStyle(
                        color: textColor != null
                            ? textColor
                            : darkMode
                                ? Colors.white
                                : Colors.black,
                        fontSize: 30),
                  )
                : Icon(
                    icon,
                    color: iconColor,
                    size: 30,
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buttonOval({required String title, double padding = 16}) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ProContainer(
        darkMode: darkMode,
        borderRadius: BorderRadius.circular(50),
        padding:
            EdgeInsets.symmetric(horizontal: padding, vertical: padding / 2),
        child: Container(
          width: padding * 2,
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                  color: darkMode ? Colors.white : Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buttonOvalIcon({required String title, double padding = 16}) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ProContainer(
        darkMode: darkMode,
        borderRadius: BorderRadius.circular(50),
        padding:
            EdgeInsets.symmetric(horizontal: padding, vertical: padding / 2),
        child: Container(
          width: padding * 2,
          child: Center(
            child: Icon(Icons.history,
                size: 18, color: darkMode ? Colors.green : Colors.redAccent),
          ),
        ),
      ),
    );
  }

  Widget _switchModeSmall({double padding = 16}) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: ProContainer(
        darkMode: darkMode,
        borderRadius: BorderRadius.circular(40),
        padding:
            EdgeInsets.symmetric(horizontal: padding, vertical: padding / 2),
        child: Container(
          width: padding * 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.wb_sunny,
                color: darkMode ? Colors.grey : Colors.redAccent,
                size: padding,
              ),
              // const SizedBox(width: 2,),
              Icon(
                Icons.nightlight_round,
                color: darkMode ? Colors.green : Colors.grey,
                size: padding,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _switchMode() {
    return ProContainer(
      darkMode: darkMode,
      borderRadius: BorderRadius.circular(40),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        width: 70,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.wb_sunny,
              color: darkMode ? Colors.grey : Colors.redAccent,
            ),
            Icon(
              Icons.nightlight_round,
              color: darkMode ? Colors.green : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

class ProContainer extends StatefulWidget {
  // Container(
  // child: Center(
  // child: ProContainer(darkMode: darkMode,child: Icon(Icons.android,size: 100,),
  // borderRadius:BorderRadius.circular(10) ,
  // padding: EdgeInsets.all(20),
  // ),
  // ),
  // ),
  final bool darkMode;
  final Widget child;
  final BorderRadius borderRadius;
  final EdgeInsetsGeometry padding;

  const ProContainer(
      {super.key,
      this.darkMode = false,
      required this.child,
      required this.borderRadius,
      required this.padding});

  @override
  _ProContainerState createState() => _ProContainerState();
}

class _ProContainerState extends State<ProContainer> {
  bool _isPressed = false;

  void _onPointerDown(PointerDownEvent event) {
    setState(() {
      _isPressed = true;
    });
  }

  void _onPointerUp(PointerUpEvent event) {
    setState(() {
      _isPressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool darkMode = widget.darkMode;
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      child: Container(
        padding: widget.padding,
        decoration: BoxDecoration(
          color: darkMode ? colorDark : colorLight,
          borderRadius: widget.borderRadius,
          boxShadow: _isPressed
              ? null
              : [
                  BoxShadow(
                      color:
                          darkMode ? Colors.black54 : Colors.blueGrey.shade200,
                      offset: const Offset(4.0, 4.0),
                      blurRadius: 15.0,
                      spreadRadius: 1.0),
                  BoxShadow(
                      color: darkMode ? Colors.blueGrey.shade700 : Colors.white,
                      offset: const Offset(-4.0, -4.0),
                      blurRadius: 15.0,
                      spreadRadius: 1.0)
                ],
        ),
        child: widget.child,
      ),
    );
  }
}

class HistoryScreen extends StatelessWidget {
  final TextEditingController controller = TextEditingController();

  HistoryScreen({super.key});

  final ValueNotifier<String> searchKeyWordNotifier = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<History>(historyBoxName);

    final themData = Theme.of(context);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Share.share('https://cafebazaar.ir/app/com.mowludi.procalculator',
                subject: 'Pro Calculator');
          },
          label: Row(
            children: const [
              // Text(''),
              // SizedBox(
              //   width: 4,
              // ),
              Icon(
                CupertinoIcons.share,
                size: 20,
              ),
            ],
          )),
      body: SafeArea(
        // ستون اصلی
        child: Column(
          children: [
            // نوار بار و سرچ داخل آن
            Container(
              height: 114,
              decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                themData.colorScheme.primary,
                themData.colorScheme.primaryContainer
              ])),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Calculate History',
                          style: themData.textTheme.headlineSmall!
                              .apply(color: themData.colorScheme.onPrimary),
                        ),
                        InkWell(
                          onTap: () {
                            Share.share(
                                'https://cafebazaar.ir/app/com.mowludi.procalculator',
                                subject: 'Pro Calculator');
                            //_onShare(context, 'https://www.youtube.com');
                            // ShareClass.shareMethod(
                            // message:
                            // "Join me on App! It is an awesome and secure app we can use"
                            // " to connect with each other "
                            // "Download it at: ${Platform.isAndroid ? "https://play.google.com/store/apps/details?id" : "https://apps.apple.com/us/app/app"}");
                            // }
                          },
                          child: Icon(
                            CupertinoIcons.share,
                            color: themData.colorScheme.onPrimary,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      height: 40,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: themData.colorScheme.onPrimary,
                          borderRadius: BorderRadius.circular(19),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20)
                          ]),
                      child: TextField(
                        keyboardType: TextInputType.number,
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                        maxLines: 1,
                        onChanged: (value) {
                          //setState(() {});
                          searchKeyWordNotifier.value = controller.text;
                        },
                        controller: controller,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              CupertinoIcons.search,
                              size: 20,
                            ),
                            label: Text(
                              'Search histories...',
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            //++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            Expanded(
              child: ValueListenableBuilder<String>(
                valueListenable: searchKeyWordNotifier,
                builder: (context, value, child) {
                  return ValueListenableBuilder<Box<History>>(
                    valueListenable: box.listenable(),
                    builder: (context, box, child) {
                      {
                        // این راه برای سرچ بهینه نیست و باعث میشه کل درخت صفحه اصلی از نو ساخته بشه . پس این قسمت کامنت شد و راه جدید پیاده شد
                        // final items;
                        // if (controller.text.isEmpty) {
                        //   items = box.values.toList();
                        // } else {
                        //   items = box.values.where((Task element) =>
                        //       element.name.contains(controller.text)).toList();
                        // }
                      }

                      final List<History> items;
                      if (controller.text.isEmpty) {
                        items = box.values.toList();
                      } else {
                        items = box.values
                            .where((History element) =>
                                element.calculate.contains(controller.text))
                            .toList();
                      }

                      if (items.isNotEmpty) {
                        return ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 200),
                            itemCount: (items.length + 1),
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Today',
                                            style: themData
                                                .textTheme.headlineSmall!
                                                .apply(fontSizeFactor: 0.9),
                                          ),
                                          Container(
                                            margin:
                                                const EdgeInsets.only(top: 4),
                                            width: 70,
                                            height: 4,
                                            decoration: BoxDecoration(
                                                color: colorDark,
                                                borderRadius:
                                                    BorderRadius.circular(2)),
                                          )
                                        ],
                                      ),
                                      MaterialButton(
                                        color: const Color(0xffEAEFF5),
                                        elevation: 0,
                                        textColor: Colors.black,
                                        onPressed: () {
                                          box.clear();
                                        },
                                        child: Row(children: const [
                                          Text(
                                            'Delete All',
                                            style: TextStyle(color: colorDark),
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Icon(
                                            CupertinoIcons.delete_solid,
                                            size: 20,
                                            color: colorDark,
                                          )
                                        ]),
                                      )
                                    ]);
                              } else {
                                try {
                                  final History task = items[((items.length ) - (index ))];
                                  return TaskItem(task: task);
                                } catch (e, s) {
                                  //print(s);
                                  return const EmptyState();
                                }
                              }
                            });
                      } else {
                        return const EmptyState();
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskItem extends StatefulWidget {
  static const double height = 84;
  static const double borderRadius = 8;
  final History task;

  const TaskItem({super.key, required this.task});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    final themData = Theme.of(context);
    const Color priorityColor = Colors.orange;

    return InkWell(
      onTap: () {
        // Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditTaskScreen(task: widget.task)));
      },
      onLongPress: () {
        // final box = Hive.box<Task>(taskBoxName);
        // box.delete(widget.task.key);
        widget.task.delete();
      },
      child: Container(
        height: TaskItem.height,
        margin: const EdgeInsets.only(top: 8),
        padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(TaskItem.borderRadius),
            color: themData.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                blurRadius: 10,
                color: Colors.black.withOpacity(0.14),
              )
            ]),
        child: Column(
          //height: TaskItem.height,

          children: [
            Text(widget.task.time,
                style: const TextStyle(
                  fontSize: 14,
                )),
            const SizedBox(
              height: 8,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Expanded(
                //contains a single child which is scrollable
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  //for horizontal scrolling
                  scrollDirection: Axis.horizontal,
                  child: Text(widget.task.calculate,
                      //overflow: TextOverflow.ellipsis,
                      //overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      )),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Your history is empty.',
        ),
        const SizedBox(
          height: 16,
        ),
        Image.asset(
          'assets/empty_state_history.png',
          width: 200,
        ),
      ],
    );
  }
}

void _onShare(BuildContext context, String text) async {
  final box = context.findRenderObject() as RenderBox?;
  await Share.share(text,
      subject: 'Share',
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
}

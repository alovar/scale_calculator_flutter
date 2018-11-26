import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Scale Calcualtor",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Scale Calculator"),
        ),
        body: Body(),
      ),
    ));

class Body extends StatefulWidget {
  @override
  BodyState createState() {
    return BodyState();
  }
}

class BodyState extends State<Body> {
  double scale = 0.0;
  int typeScale = 1;

  int whereIs = 0;

  double scaleFrom = 0.0;
  double scaleTo = 0.0;

  double answer = 0.0;
  int typeAnswer = 0;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            valueWidget(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: DropdownButton(
                value: whereIs,
                items: [
                  DropdownMenuItem(
                    child: Text("На местности"),
                    value: 0,
                  ),
                  DropdownMenuItem(
                    child: Text("На чертеже"),
                    value: 1,
                  ),
                ],
                onChanged: (value) {
                  whereIs = value;
                  calculate();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "В масштабе:",
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            scaleWidget(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text("Результат:", style: TextStyle(fontSize: 18.0)),
            ),
            Text(
              "Масштаб $scaleFrom:$scaleTo показывает, "
                  "что $scale ${typeScaleStr(typeScale)} ${whereIsStr(false)} "
                  "соответствует $answer ${typeScaleStr(typeAnswer)} "
                  "${whereIsStr(true)}.",
              style: TextStyle(fontSize: 16.0),
            )
          ],
        ),
      ),
    );
  }

  Row valueWidget() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: TextField(
            onChanged: (value) {
              scale = double.parse(value);
              calculate();
            },
            keyboardType: TextInputType.numberWithOptions(),
            decoration: InputDecoration(labelText: "Значение"),
          ),
        ),
        Expanded(
            flex: 0,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 11.0, left: 4.0),
              child: DropdownButtonHideUnderline(
                child: DropdownButton(
                  value: typeScale,
                  isDense: true,
                  items: [
                    DropdownMenuItem(
                      child: Text("мм"),
                      value: 0,
                    ),
                    DropdownMenuItem(
                      child: Text("см"),
                      value: 1,
                    ),
                    DropdownMenuItem(
                      child: Text("м"),
                      value: 2,
                    ),
                    DropdownMenuItem(
                      child: Text("км"),
                      value: 3,
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      typeScale = value;
                      calculate();
                    });
                  },
                ),
              ),
            ))
      ],
    );
  }

  Row scaleWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Expanded(
          child: TextField(
            onChanged: (value) {
              scaleFrom = double.parse(value);
              calculate();
            },
            keyboardType: TextInputType.numberWithOptions(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "к",
            style: TextStyle(fontSize: 16.0),
          ),
        ),
        Expanded(
          child: TextField(
            onChanged: (value) {
              scaleTo = double.parse(value);
              calculate();
            },
            keyboardType: TextInputType.numberWithOptions(),
          ),
        ),
      ],
    );
  }

  void calculate() {
    typeAnswer = 0;

    if (whereIs == 0) {
      //чертёж -> местность
      answer = scaleTo != 0 ? (scale * scaleFrom / scaleTo) : 0.0;

    } else {
      // метсночть -> чертеж
      answer = scaleFrom != 0 ? (scale * scaleTo / scaleFrom) : 0.0;
    }

    print("1 = $typeScale $scale $answer");

    switch (typeScale) {
      case 1:
        answer *= 10;
        break;
      case 2:
        answer *= 100 * 10;
        break;
      case 3:
        answer *= 1000 * 100 * 10;
        break;
    }

    for (int i = 0; i < 3; i++) {
      switch (typeAnswer) {
        case 0: // 10mm = 1 cm
          if (answer >= 10) {
            answer /= 10;
            ++typeAnswer;
          }
          break;
        case 1: // 100 cm = 1 m
          if (answer >= 100) {
            answer /= 100;
            ++typeAnswer;
          }
          break;
        case 2: // 1000 m = 1 km
          if (answer >= 1000) {
            answer /= 1000;
            ++typeAnswer;
          }
      }
    }

    answer = double.parse(answer.toStringAsFixed(2));

    setState(() {});
  }

  String typeScaleStr(int type) {
    switch (type) {
      case 0:
        return "мм";
      case 1:
        return "см";
      case 2:
        return "м";
      case 3:
        return "км";
      default:
        return "{error}";
    }
  }

  String whereIsStr(bool inversion) {
    if (inversion) {
      return whereIs != 0 ? "на местности" : "на чертеже";
    } else {
      return whereIs == 0 ? "на местности" : "на чертеже";
    }
  }
}

import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final VoidCallback? onPress;
  final String? text;
  final Color? buttonColor;
  final bool? isOperationButton;

  Button({
    this.onPress,
    this.text,
    this.buttonColor,
    this.isOperationButton,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: ElevatedButton(
          onPressed: onPress ?? () {},
          style: ElevatedButton.styleFrom(
            primary: buttonColor,
          ),
          child: Text(
            text ?? '',
            style: TextStyle(
              color: isOperationButton ?? false ? Colors.black : Colors.white,
              fontSize: 20,
            ),
          ),
        ),
      ),
    );
  }
}

class ButtonRow extends StatelessWidget {
  final List<Map<String, dynamic>> buttons;

  ButtonRow({this.buttons = const []});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: buttons
          .map(
            (button) => Button(
              onPress: button['onPress'],
              text: button['text'],
              buttonColor: button['buttonStyle'],
              isOperationButton: button['isOperationButton'] ?? false,
            ),
          )
          .toList(),
    );
  }
}

class CalculatorApp extends StatefulWidget {
  @override
  _CalculatorAppState createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  String expression = '';
  String result = '';

  void handlePress(String value) {
    if (value == '=') {
      try {
        double res = calculate(expression);
        setState(() {
          result = res.toString();
        });
      } catch (error) {
        setState(() {
          result = 'Error';
        });
      }
    } else if (value == 'C') {
      setState(() {
        expression = '';
        result = '';
      });
    } else {
      setState(() {
        expression += value;
      });
    }
  }

  double calculate(String expression) {
    double result = 0;
    try {
      result = eval(expression);
    } catch (e) {
      throw Exception('Invalid expression');
    }
    return result;
  }

  double eval(String expression) {
    List<String> tokens = expression.split('');
    List<String> operators = ['+', '-', '*', '/'];
    List<String> postfix = [];
    List<double> stack = [];

    for (var token in tokens) {
      if (!operators.contains(token)) {
        postfix.add(token);
      } else {
        while (operators.isNotEmpty &&
            precedence(operators.last) >= precedence(token)) {
          postfix.add(operators.removeLast());
        }
        operators.add(token);
      }
    }

    while (operators.isNotEmpty) {
      postfix.add(operators.removeLast());
    }

    for (var token in postfix) {
      if (!operators.contains(token)) {
        stack.add(double.parse(token));
      } else {
        double b = stack.removeLast();
        double a = stack.removeLast();
        switch (token) {
          case '+':
            stack.add(a + b);
            break;
          case '-':
            stack.add(a - b);
            break;
          case '*':
            stack.add(a * b);
            break;
          case '/':
            stack.add(a / b);
            break;
          default:
            throw Exception('Invalid operator');
        }
      }
    }

    if (stack.length != 1) {
      throw Exception('Invalid expression');
    }

    return stack.first;
  }

  int precedence(String op) {
    switch (op) {
      case '+':
      case '-':
        return 1;
      case '*':
      case '/':
        return 2;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<List<Map<String, dynamic>>> buttons = [
      [
        {'text': 'C', 'buttonStyle': Colors.green, 'isOperationButton': false}
      ],
      [
        {'text': '7'},
        {'text': '8'},
        {'text': '9'},
        {
          'text': '/',
          'buttonStyle': Colors.grey,
          'isOperationButton': true,
        }
      ],
      [
        {'text': '4'},
        {'text': '5'},
        {'text': '6'},
        {
          'text': '*',
          'buttonStyle': Colors.grey,
          'isOperationButton': true,
        }
      ],
      [
        {'text': '1'},
        {'text': '2'},
        {'text': '3'},
        {
          'text': '-',
          'buttonStyle': Colors.grey,
          'isOperationButton': true,
        }
      ],
      [
        {'text': '0'},
        {'text': '.'},
        {'text': '=', 'buttonStyle': Colors.orange},
        {
          'text': '+',
          'buttonStyle': Colors.grey,
          'isOperationButton': true,
        }
      ],
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    expression,
                    style: TextStyle(fontSize: 24),
                  ),
                  Text(
                    result,
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: buttons
                .map((row) => ButtonRow(
                        buttons: row.map((button) {
                      return {
                        ...button,
                        'onPress': () => handlePress(button['text']),
                      };
                    }).toList()))
                .toList(),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: CalculatorApp(),
  ));
}

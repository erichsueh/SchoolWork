from stack import Stack

def tokenize(string):
    separators = set(' ')
    operators = set('+-*/^&')
    parentheses = set('()')
    tokens = []
    # to store the tokens to return
    buff = []
    # to store and combine consecutive digits
    for c in string:
	if c in separators or c in operators or c in parentheses:
	    if len(buff)>0:
		tokens.append(float(''.join(buff)))
		buff = []
            if c in operators or c in parentheses:
                tokens.append(c)
            elif c not in separators:
     		# digits and the decimal point and possibly something illegal
                buff.append(c)
            if len(buff)>0:
                tokens.append(float(''.join(buff)))
                return tokens
def infixToPostfix(tokenList):
    operators = set('+-*/^&')
    prec = {}
    prec["^"] = 4
    prec["&"] = 4
    prec["*"] = 3
    prec["/"] = 3
    prec["+"] = 2
    prec["-"] = 2
    prec["("] = 1
    opStack =Stack()
    postfixList = []
    for token in tokenList:
	if isFloat(token):
	    postfixList.append(token)
        elif token =='(':
	    opStack.push(token)
	elif token ==')':
	    if opStack.isEmpty():
		raise Exception('Unmatched parenthesis: )')
	    topToken = opStack.pop()
	    while topToken !='(':
		postfixList.append(topToken)
		if opStack.isEmpty():
		    raise Exception('Unmatched parenthesis: )')
		topToken = opStack.pop()
	else:
	    while(not opStack.isEmpty()) and \
	         (prec[opStack.peek()] >= prec[token]):
		postfixList.append(opStack.pop())
	    opStack.push(token)
    while not opStack.isEmpty():
	topToken=opStack.pop()
	if topToken =='(':
	    raise Exception('Unmatched parenthesis: (')
	postfixList.append(topToken)
    return " ".join(postfixList) 

def postfixEval(postfixExpr):
    operandStack =Stack()
    for token in postfixExpr:
	if isFloat(token):
	    operandStack.push(token)
	else:
	    operand2 = operandStack.pop()
	    operand1 = operandStack.pop()
	    result = doMath(token,operand1,operand2)
	    operandStack.push(result)
    result=operandStack.pop()
    if operandStack.isEmpty() == False:
	raise Exception("Unmatched operand")
    return result

def doMath(op, op1, op2):
    if op =="*":
	return op1 * op2
    elif op =="/":
	return op1 / op2
    elif op =="+":
	return op1 + op2
    elif op =="-":
	return op1 - op2
    elif op =="^":
	return op1**op2
    elif op =="&":
	return op2**(1.0/op1)
    else:
	raise Exception("Unknown Operator")

def isFloat(s):
    try:
        float(s)
        return True
    except ValueError:
        return False

def main():
    string =input('Enter: ')
    while string !='exit':
        try:
            tokenList = tokenize(string)
            postfixList = infixToPostfix(tokenList)
            result = postfixEval(postfixList)
            print('Result: %f'%result)
        except ValueError as inst:
            print('ValueError:', inst.args)
        except ZeroDivisionError as inst:
            print('ZeroDivisionError ',inst.args)
        except Exception as inst:
            print('Invalid request: ', inst.args)
        string =input('Enter: ')

main()
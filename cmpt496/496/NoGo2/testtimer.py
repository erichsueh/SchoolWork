import signal

def handler(signum, frame):
    print ("dicks")

def cunts():
    while(True):
        print("lol")

try:
    signal.signal(signal.SIGALRM, handler)
    signal.alarm(5)
    cunts()
    signal.alarm(0)
except(RuntimeError):
    print("tooslow")

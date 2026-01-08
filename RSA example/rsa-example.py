#!/usr/bin/env python

# Python example for RSA algorithm by M. Schapranow
import time # used for timing measurement

# check whether the given number n is prime
def numberIsPrime(n):
    if n < 2:
        return False
    s=generateSieveEratosthenesFor(n)
    return s[n]

# create sieve of Eratosthenes up to n
def generateSieveEratosthenesFor(n):
    sieve = [True] * (n + 1)
    sieve[0] = sieve[1] = False

    for i in range(2, int(n**0.5) + 1):
        #print(f"i: {i}")
        if sieve[i]:
            for j in range(i * i, n + 1, i):
                #print(f"j: {j}")
                sieve[j] = False

    return sieve

# generate a list of prime numbers from 1..n
def generatePrimeNumers(n):
    primes=[]
    s=generateSieveEratosthenesFor(n)
    for i in range(2, n+1):
        if s[i]:
            primes += [i]
    return primes

def power(base, expo, m):
    res = 1
    base = base % m
    while expo > 0:
        if expo & 1:
            res = (res * base) % m
        base = (base * base) % m
        expo = expo // 2
    return res

# calculate greatest common divisor
def gcd(a, b):
    while b != 0:
        a, b = b, a % b
    return a

# extended euclidean algorithmn 
def egcd(a, b):
    x,y, u,v = 0,1, 1,0
    while a != 0:
       q, r = b//a, b%a
       m, n = x-u*q, y-v*q
       b,a, x,y, u,v = a,r, u,v, m,n
    return b, x, y


# extensive test for modInverse
def modInverse(e, phi):
    for d in range(2, phi):
        if (e * d) % phi == 1:
            return d
    return None

# modInverse using extended euclidean algorithmn
def modInverseFast(a, m):
    g, x, y = egcd(a, m)
    if g != 1:
       return None # modular inverse does not exist
    else:
       return x % m

def printRuntime(ts_start, ts_end):
    print(f"{(ts_end-ts_start)*1000:.3f} ms")

# select enc key for phi
def selectEncKey(phi):
    # enc candidates are larger one and lower phi
    enc_cand=list(range(2, phi))

    # introduce some randomness to select not always the same candidate
    #random.shuffle(enc_cand)

    for c in enc_cand:
        # check if gcd(phi) == 1 
        if gcd(c, phi) == 1:
            return c

    return None  

# generate prime numbers using sieve of Eratosthenes w/o user interaction
def getPrimeNumbersAutomatically():
    # we only use lib random to pick a random number from the list of primes 
    import random
    s=generatePrimeNumers(pow(2, 14))

    primes = []

    # check if priems are no neighbors
    while not primes or (abs(primes[1] - primes[0]) < 3):
        # default values, ask for two prime numbers
        primes = [0, 0]
        for i in range(0,len(primes)):
                primes[i] = random.choice(s)
    return primes[0], primes[1]

# ask user for prime number input and check if numbers are prime using sieve of Erastothenes
def getPrimeNumbersFromUser():
    primes = []
    # no neighbors
    while not primes or (abs(primes[1] - primes[0]) < 3):
        # default values, ask for two prime numbers222
        primes = [0, 0]
        for i in range(0,len(primes)):
            while not numberIsPrime(primes[i]):    
                primes[i] = int(input("Please enter " + str(i+1) + ". prime number: "))
    return primes[0], primes[1]

# generate keypair
def generateKeys():
    print("*** STEP 1: Pick two different huge prime numbers (𝑝, 𝑞) (no neighbors).")
    inp = None
    while inp != "a" and inp != "b": 
        inp = input("Please select: a) to specify prime numbers on your own or b) to generate prime numbers (a/b): ").lower()

    match inp:
        case "a":
            p, q = getPrimeNumbersFromUser()
        case "b":
            p, q = getPrimeNumbersAutomatically()

    print(f"p={p}, q={q}.")

    ts_start = time.process_time()
    N = p*q
    ts_end = time.process_time()
    print(f"*** STEP 2: Calculate semiprime modulus 𝑁 = 𝑝∙𝑞 = {p}∙{q} = {N}. (Beware: this is largest value you can encrypt.)")
    print(f"{(ts_end-ts_start)*1000:.3f} ms")

    ts_start = time.process_time()
    phi = (p - 1) * (q - 1)
    ts_end = time.process_time()
    print(f"*** STEP 3: Calculate Euler’sche phi function of 𝑁 as 𝜑(𝑁) = (𝑝−1)∙(𝑞−1) = {p-1}∙{q-1} = {phi}")
    printRuntime(ts_start, ts_end)

    print(f"*** STEP 4: Choose a number 1 < 𝑒𝑛𝑐 < 𝜑(𝑛) with gcd⁡(𝑒𝑛𝑐, 𝜑(𝑛)) = 1: ", end = "")
    ts_start = time.process_time()
    key_enc = selectEncKey(phi)
    ts_end = time.process_time()
    print(f"𝑒𝑛𝑐 is {key_enc}.")
    printRuntime(ts_start, ts_end)

    print("*** STEP 5: Derive inverse of 𝑒𝑛𝑐: 1<𝑑𝑒𝑐 with (𝑒𝑛𝑐∙𝑑𝑒𝑐) 𝑚𝑜𝑑 𝜑(𝑛)=1: ", end = "")
    ts_start = time.process_time()
    key_dec = modInverseFast(key_enc, phi)
    ts_end = time.process_time()
    print(f"𝑑𝑒𝑐 is {key_dec}.")
    printRuntime(ts_start, ts_end)

    print("")
    print("<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>")
    print(f"   Public key (N, enc): ({N}, {key_enc})")
    print(f"  Private key (N, dec): ({N}, {key_dec})")
    print("<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>")

    return key_enc, key_dec, N

# convert given msg to array of ascii codes
def text2ascii(msg, N):
    msg_ascii = []
    for c in msg:
        a = ord(c)
        if a > N:
            print(f"WARNING: {a} ({c}) > {N}. You need to chose larger prime numbers to be able to handle this value properly!")
        msg_ascii += [ord(c)]
    return msg_ascii

# convert ASCII-encoded msg back to string
def ascii2text(msg):
    return bytearray(msg).decode()
     
# encrypt given array of in message using enc key and N  
def msg2cipher(msg_ascii, enc, N):
    cipher=[]
    for c in msg_ascii:
        cipher += [power(c, enc, N)]
    return cipher

# decrypt given cipher array using dec key and N
def cipher2msg(cipher, dec, N):
    dec_ascii=[]
    for c in cipher:
        dec_ascii += [power(c, dec, N)]

    return dec_ascii

# RSA encryption
def encryptMessage(msg, enc, N):
    print(f"*** STEP 1: Conversion of text message to corresponding ASCII codes: ", end="")
    ts_start = time.process_time()
    msg_ascii = text2ascii(msg, N)
    ts_end = time.process_time()
    print(f"{msg} --> {msg_ascii}")
    printRuntime(ts_start, ts_end)


    print(f"*** STEP 2: Encryption: cipher(𝑚𝑠𝑔) = 𝑚𝑠𝑔^𝑒𝑛𝑐 𝑚𝑜𝑑 𝑁 = 𝑚𝑠𝑔^{enc} 𝑚𝑜𝑑 {N}")
    ts_start = time.process_time()
    cipher = msg2cipher(msg_ascii, enc, N)
    ts_end = time.process_time()
    printRuntime(ts_start, ts_end)
    return cipher

# RSA decryption
def decryptCipher(cipher, dec, N):
    print(f"*** STEP 1: Decryption: message(𝑐𝑖𝑝ℎ𝑒𝑟) = 𝑐𝑖𝑝ℎ𝑒𝑟^𝑑𝑒𝑐 𝑚𝑜𝑑 𝑁 = 𝑐𝑖𝑝ℎ𝑒𝑟^{dec} 𝑚𝑜𝑑 {N}")

    # decrypt cipher
    ts_start = time.process_time()
    dec_ascii = cipher2msg(cipher, dec, N)
    ts_end = time.process_time()
    print(f"Decrypted cipher encoded as ASCII codes: {dec_ascii}.")
    printRuntime(ts_start, ts_end)

    print(f"*** STEP 2: Conversion of ASCII codes back to text message: ", end="")
    ts_start = time.process_time()
    dec_msg = ascii2text(dec_ascii)
    ts_end = time.process_time()
    print(f"{dec_ascii} --> {dec_msg}.")
    printRuntime(ts_start, ts_end)

    return dec_msg

# Main execution
if __name__ == "__main__":

    # KEYS
    print("Welcome to the ITS4DH RSA example code.")
    print("I will help you to generate a proper key pair for RSA-based encryption/decryption.")
    enc, dec, N = generateKeys()
    print("")

    # ENCRYPTION
    msg = input("Please provide your message to encrypt: ")
    print("Let's start encryption...")
    cipher = encryptMessage(msg, enc, N)
    print(f"==> Message \"{msg}\" encrypted to cipher {cipher}.")
    print("")
  
    # DECRYPTION
    print("Let's start decryption...")
    dec_msg = decryptCipher(cipher, dec, N)
    print(f"==> Cipher {cipher} decyrpted to cleartext message \"{dec_msg}\".")

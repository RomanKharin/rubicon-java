import rubicon

if __name__ == '__main__':
    print("Start from another thread")
    t = rubicon._test_rubicon
    t["c"] = t["a"] + t["b"]
    

class Logger:
    def __init__(self, file_name):
        self.file_name = file_name

    def log(self, message):
        with open(self.file_name, "a") as f:  # 'a' = append mode
            f.write(message + "\n")

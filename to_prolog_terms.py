import sys

def changed(file):
    lines = []
    with open(file, "r") as f:
        with open(file+"pl", "w") as newf:
            lines = f.readlines()
            lines = [x.strip() for x in lines]
            lines = [x for x in lines if x != '']
            lines = [x.replace('`', '|') for x in lines]
            lines = [f"`{x}`." for x in lines]
            # print(lines)
            newf.write('\n'.join(lines))
            # for line in f:
                # print(f"`{line.strip()}`.\n")
                # if line.strip() != '':
                    # newf.write(f"`{line.strip()}`.\n")
                # TODO delete last white line join with \n why not in lines

if __name__ == '__main__':
    file = sys.argv[1]
    changed(file)
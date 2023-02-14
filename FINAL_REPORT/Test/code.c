int main() {
    int n1 = 75, n2 = 50, max;
    max = (n1 > n2) ? n1 : n2;
    while (1) {
        if ((max % n1 == 0) && (max % n2 == 0)) {
            break;
        }
        ++max;
    }
    return 0;
}
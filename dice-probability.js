// ダイスの確率表生成

// 参考 Java の直積ライブラリ 
// Eclipse Collections Sets.cartesianProduct https://www.eclipse.org/collections/javadoc/9.0.0/org/eclipse/collections/impl/factory/Sets.html#cartesianProduct-java.util.Set-java.util.Set-
// Guava https://google.github.io/guava/releases/21.0/api/docs/com/google/common/collect/Sets.html#cartesianProduct-java.util.Set...-
// Eclipse Collectionsのは static <A,B> LazyIterable<Pair<A,B>>	cartesianProduct(Set<A> set1, Set<B> set2) で、A×B にのみ対応している
// （A×B×Cは結合順に応じてPair<Pair<A, B>, C>またはPair<A, Pair<B, C>>で表現することになる）
// Guavaのは Set<List<B>> cartesianProduct(Set<? extends B>... sets) で A^n にのみ対応している（A×Bを表現することはできない）
// n-Tupleのない静的型付き言語では仕方ないところではある

// 組み合わせ爆発でろくなことにならないからフラットに舐めた方がパフォーマンス的に良さそうではある

// 直積(2項)
function product2(array1, array2) {
    return array1.map(e1 => array2.map(e2 => [e1, e2])) // [[[1,1],[1,2]], [[2,1],[2,2]]]
                .reduce((a1, a2) => a1.concat(a2)); // [[1,1], [1,2], [2,1], [2,2]]
}

// 左辺が配列なら展開する
function toFlatArray(e1, e2) {
    if(Array.isArray(e1)) {
        return [...e1, e2];
    } else {
        return [e1, e2];
    }
}
// 直積(n項)
// 可変長で配列を受け取り、それらの配列の直積を配列の配列として返す
function product() {
    const args = [...arguments];
    // 引数がひとつしかなければそのまま返して終了
    let partialProduct = args.shift();
    if(args.length === 0) {
        return partialProduct;
    }
    // 2番目の引数を最初の引数に直積として結合する
    const curr = args.shift();
    partialProduct = partialProduct.map(e1 => curr.map(e2 => toFlatArray(e1, e2))) // [[[1,1],[1,2]], [[2,1],[2,2]]]
                                   .reduce((a1, a2) => a1.concat(a2)); // [[1,1], [1,2], [2,1], [2,2]]
    // 再帰的に引数が1つになるまで繰り返す
    return product(partialProduct, ...args);
}

// console.log(product([1,2,3],["a","b","c"],["い","ろ","は"]));

// ダイスの面数
const diceRange = 4;
// ダイスの個数
const diceCount = 3;

// 1個のダイスの目
// [1, 2, 3, ... , diceRange]
const dice = [...Array(diceRange)].map((v,i) => i + 1);
// ダイス1セットの目の組み合わせ
// [[1,1], [1,2], ..., [1,6], [2,1], ..., [6,6]]
const setOfDice = product(...Array(diceCount).fill(dice));
// console.log(setOfDice);

// // [1, 2, 3, 4, 5, 6]
// const dice = [...Array(6)].map((v,i) => i + 1);
// // [[[1,1],[1,2],...,[1,6]],
// //  [[2,1],[2,2],...],
// //  ...]
// // TODO これ3個以上でやるには？
// const dicePairNest = dice.map(d1 => dice.map(d2 => [d1, d2]));
// // [[1,1], [1,2], ..., [6,6]]
// const dicePair = [].concat(...dicePairNest);

// ダイスの出目ごとにカウント
const countElement = (result, element) => {
    // result = result || [];
    result[element] = result[element] || 0;
    result[element]++;
    return result;
};

// ダイスの目の和に変換
const summary = array => array.reduce((sum, n) => sum + n);

// 可変長でダイスの面数を受け取り出目の確率一覧を返す
function probabilities() {
    const args = [...arguments];
    const setOfDice = args.map(diceRange => [...Array(diceRange)].map((v,i) => i + 1));
    const combination = product(...setOfDice);
    const expected = combination.map(summary).reduce(countElement, {});
    Object.keys(expected).forEach(key => expected[key] = expected[key] / combination.length);
    console.log(Object.keys(expected).map(key => expected[key]).reduce((sum, n) => sum + n));
    return expected;
}

// 4面ダイスと6面ダイス
console.log(probabilities(4, 6));
// 6面ダイス3個
console.log(probabilities(6, 6, 6));

import List "mo:base/List";
import Option "mo:base/Option";
import Trie "mo:base/Trie";
import Nat32 "mo:base/Nat32";
import Text "mo:base/Text";
import Float "mo:base/Float";

actor {
    public type ProductId = Nat32;
    public type Product = {
        name : Text;
        category : Text;
        price : Float;
        stockQuantity : Nat32;
    };

    private stable var next : ProductId = 0;
    private stable var products : Trie.Trie<ProductId, Product> = Trie.empty();

    public func create(product : Product) : async ProductId {
        let productId = next;
        next += 1;
        products := Trie.replace(
            products,
            key(productId),
            Nat32.equal,
            ?product
        ).0;
        return productId;
    };

    public query func read(productId : ProductId) : async ?Product {
        Trie.find(products, key(productId), Nat32.equal)
    };

    public func update(productId : ProductId, product : Product) : async Bool {
        switch (Trie.find(products, key(productId), Nat32.equal)) {
            case (null) false;
            case (_) {
                products := Trie.replace(
                    products,
                    key(productId),
                    Nat32.equal,
                    ?product
                ).0;
                true;
            };
        };
    };

    public func delete(productId : ProductId) : async Bool {
        switch (Trie.find(products, key(productId), Nat32.equal)) {
            case (null) false;
            case (_) {
                products := Trie.replace(
                    products,
                    key(productId),
                    Nat32.equal,
                    null
                ).0;
                true;
            };
        };
    };

    private func key(x : ProductId) : Trie.Key<ProductId> {
        { hash = x; key = x }
    };
}

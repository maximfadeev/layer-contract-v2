;; ====================================== EDITIONS LOGIC ======================================

;; (define-public (mint-editions (edition-ids (list 10000 uint)) (all-token-data {minter: principal, metadata: (string-ascii 256), data: {price: uint, for-sale: bool}, royalties: (optional (list 5 {address: principal, percentage: uint}))}))
;;   (begin
;;     (asserts! (is-admin) ERR-NOT-AUTHORIZED)
;;     (ok (get responses (fold mint-edition edition-ids (merge {all-token-data: all-token-data} {responses: (list )}))))
;;   )
;; )

;; (define-private (mint-edition (token-id uint) (editions-data {responses: (list 10000 (response uint uint)), all-token-data: {minter: principal, metadata: (string-ascii 256), data: {price: uint, for-sale: bool}, royalties: (optional (list 5 {address: principal, percentage: uint}))}}))
;;   (if 
;;     (is-ok 
;;       (mint (merge {token-id: token-id} (get all-token-data editions-data)))
;;     )
;;     (merge editions-data {responses: (append (get responses editions-data) (ok token-id))})
;;     (merge editions-data {responses: (append (get responses editions-data) (err token-id))})
;;   )
;; )

;; '(tuple (all-token-data (tuple (data (tuple (for-sale bool) (price uint))) (metadata (string-ascii 256)) (minter principal) (royalties (optional (list 5 (tuple (address principal) (percentage uint))))))) (responses (list 10000 (response uint uint))))'
;; '(tuple (all-token-data (tuple (data (tuple (for-sale bool) (price uint))) (metadata (string-ascii 256)) (minter principal) (royalties (optional (list 5 (tuple (address principal) (percentage uint))))))) (responses (list 10001 (response uint uint))))'


;; ====================================== LOCKED PURCHASE AND OLD LOGIC ======================================

;; (define-map locked-purchases uint {buyer: principal, price: uint})


;; (define-private (mint-purchase (all-token-data {token-id: uint, minter: principal, metadata: (string-ascii 256), data: {price: uint, for-sale: bool}, royalties: (optional (list 5 {address: principal, percentage: uint}))}))
;;   (let (
;;     (token-id (get token-id all-token-data))
;;     (minter (get minter all-token-data))
;;     (price (get price (get data all-token-data)))
;;   )
;;     (try! (mint all-token-data))
;;     (try! (pay-transfer token-id minter minter tx-sender price))
;;     (ok token-id)
;;   )
;; )

;; auto return funds (!)
;; mint nft regardless of success (x)
;; (define-private (mint-complete-purchase (all-token-data {token-id: uint, minter: principal, metadata: (string-ascii 256), data: {price: uint, for-sale: bool}, royalties: (optional (list 5 {address: principal, percentage: uint}))}))
;;   (let (
;;     (token-id (get token-id all-token-data))
;;     (minter (get minter all-token-data))
;;     (price (get price (get data all-token-data)))
    ;; (purchase-data (unwrap! (map-get? locked-purchases token-id) ERR-TOKEN-NOT-PURCHASED))
;;     (buyer (get buyer purchase-data))
;;     (purchase-price (get price purchase-data))
;;   )
    ;; (asserts! (is-eq price purchase-price) ERR-PRICES-DO-NOT-MATCH)
;;     (try! (mint all-token-data))
;;     (try! (pay-transfer token-id minter buyer price))
;;     (ok token-id)
;;   )
;; )

;; (define-private (mint-purchase-admin (all-token-data {token-id: uint, minter: principal, metadata: (string-ascii 256), data: {price: uint, for-sale: bool}, royalties: (optional (list 5 {address: principal, percentage: uint}))}))
;;   (let (
;;     (token-id (get token-id all-token-data))
;;     (minter (get minter all-token-data))
;;     (price (get price (get data all-token-data)))
;;   )
;;     (try! (mint all-token-data))
;;     (try! (pay-transfer token-id minter minter tx-sender price))
;;     (ok token-id)
;;   )
;; )

;; (define-public (complete-sale (token-id uint) (new-owner-address principal) (old-owner-address principal) (token-price uint))
;;   (begin 
;;     (asserts! (is-admin) ERR-NOT-AUTHORIZED)
;;     (try! (pay token-id token-price old-owner-address))
;;     (ok (try! (nft-transfer? Layer-NFT token-id tx-sender new-owner-address)))
;;   )
;; )

;; (define-public (complete-sale (token-id uint) (new-owner-address principal) (old-owner-address principal) (token-price uint) (is-nft-in-escrow bool))
;;   (begin 
;;     (asserts! (is-admin) ERR-NOT-AUTHORIZED)
;;     (try! (pay token-id token-price old-owner-address))
;;     (if is-nft-in-escrow
;;      (ok (try! (nft-transfer? Layer-NFT token-id tx-sender new-owner-address)))
;;      (ok (try! (nft-transfer? Layer-NFT token-id old-owner-address new-owner-address)))
;;     )
;;   )
;; )

;; (define-public (mint-purchase-many (files (list 100 {token-id: uint, minter: principal, metadata: (string-ascii 256), data: {price: uint, for-sale: bool}, royalties: (optional (list 5 {address: principal, percentage: uint}))})))
;;   (begin
;;     (asserts! (is-admin) ERR-NOT-AUTHORIZED)
;;     (ok (map mint-purchase files))
;;   )
;; )

;; (define-private (mint-admin (all-token-data {token-id: uint, minter: principal, metadata: (string-ascii 256), data: {price: uint, for-sale: bool}, royalties: (optional (list 5 {address: principal, percentage: uint}))}) 
;; (is-direct-mint bool) (is-locked-purchase bool) (buyer (optional principal)))
;;   (let (
;;     (token-id (get token-id all-token-data))
;;     (minter (get minter all-token-data))
;;     (price (get price (get data all-token-data)))
;;   )
;;     (try! (mint all-token-data))
;;     (if is-direct-mint
;;       (ok token-id)
;;       (if is-locked-purchase
;;         (let (
          ;; (purchase-data (unwrap! (map-get? locked-purchases token-id) ERR-TOKEN-NOT-PURCHASED))
;;           (nft-recipient (get buyer purchase-data))
;;           (purchase-price (get price purchase-data))
;;         )
          ;; (asserts! (is-eq price purchase-price) ERR-PRICES-DO-NOT-MATCH)
;;           (try! (pay-transfer token-id minter nft-recipient price))
;;           (ok token-id)
;;         )
;;         (let ((nft-recipient (unwrap! buyer ERR-UNWRAPPING)))
;;           (try! (pay-transfer token-id minter nft-recipient price))
;;           (ok token-id)
;;         )
;;       )
;;     )
;;   )
;; )

;; (define-public (lock-purchase (token-id uint) (price uint))
;;   (begin
;;     (try! (stx-transfer? price tx-sender (var-get admin)))
;;     (asserts! (map-insert locked-purchases token-id {buyer: tx-sender, price: price}) ERR-NFT-ALREADY-LOCKED)
;;     (ok true)
;;   )
;; )

;; (define-private (refund-locked-purchase (token-id uint))
;;   (let (
    ;; (purchase-data (unwrap! (map-get? locked-purchases token-id) ERR-TOKEN-NOT-PURCHASED))
;;     (buyer (get buyer purchase-data))
;;     (purchase-price (get price purchase-data))  
;;   )
;;     (asserts! (is-admin) ERR-NOT-AUTHORIZED)
;;     (try! (stx-transfer? purchase-price tx-sender buyer))
;;     (ok (map-delete locked-purchases token-id))
;;   )
;; )

;; (define-constant ERR-PRICES-DO-NOT-MATCH (err u970))
;; (define-constant ERR-TOKEN-NOT-PURCHASED (err u971))
;; (define-constant ERR-NFT-ALREADY-LOCKED (err u973))
;; (define-constant ERR-CALCULATING-ROYALTIES (err u974))
;; (define-constant ERR-INSUFFICIENT-STX (err u975))
;; (define-constant ERR-FAILED-TO-MINT-TO-COLLECTION (err u980))
;; (define-constant ERR-COLLECTION-DOES-NOT-EXIST (err u981))
;; (define-constant ERR-FAILED-TO-CALCULATE-ROYALTIES (err u982))
;; (define-constant ERR-PURCHASE-FAILED (err u983))
;; (define-constant ERR-PURCHASE-NFT-TRANSFER-FAILED (err u984))
;; (define-constant ERR-TOKEN-OWNER-FAILED-TO-UNWRWAP (err u985))
;; (define-constant ERR-DATA-FAILED-TO-UNWRAP (err u986))
;; (define-constant ERR-PAY-ROYALTIES-DATA-FAILED (err u987))
;; (define-constant ERR-FAILED-TO-GET-COLLECTION-INFO (err u992))
;; (define-constant ERR-FAILED-TO-TRANSFER-TOKEN (err u994))
;; (define-constant ERR-FAILED-TO-SET-TOKEN-DATA (err u995))
;; (define-constant ERR-TOKEN-METADATA-NOT-SET (err u996))
;; (define-constant ERR-TOKEN-ID-NOT-SET (err u997))
;; (define-constant ERR-ROYALTIES-NOT-SET (err u998))
;; (define-constant ERR-GETTING-NFT-OWNER (err u999))
;; (define-constant ERR-COULD-NOT-GET-TOKEN-URI (err u1000))

;; (\/) bulk mint
;; (\/) lazy mint
;; (\/) multiple delete nft
;; (\/) multiple transfer nft
;; (X) mint editions
;; (\/) complete-sale-many
;; (\/) pay-many
;; (\/) multiple transfer stx
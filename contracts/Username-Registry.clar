;; Username Registry Contract
;; Allows users to register a unique username.

(define-map usernames principal (string-ascii 32))
(define-map username-to-owner (string-ascii 32) principal)

(define-constant err-username-taken (err u100))
(define-constant err-already-registered (err u101))
(define-constant err-invalid-name (err u102))


;; 1. Register a username
(define-public (register-username (name (string-ascii 32)))
  (begin
    ;; Check if caller already registered a username
    (asserts! (is-none (map-get? usernames tx-sender)) err-already-registered)
    ;; Validate username length > 0
    (asserts! (> (len name) u0) err-invalid-name)
    ;; Check if username already taken
    (asserts! (is-none (map-get? username-to-owner name)) err-username-taken)
    ;; Save username and reverse mapping
    (map-set usernames tx-sender name)
    (map-set username-to-owner name tx-sender)
    (ok true)
  )
)

;; 2. Get username for a principal
(define-read-only (get-username (user principal))
  (ok (map-get? usernames user)))

;; 3. Get owner for a username
(define-read-only (find-owner (name (string-ascii 32)))
  (ok (map-get? username-to-owner name)))

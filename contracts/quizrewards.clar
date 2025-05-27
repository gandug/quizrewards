;; --------------------------------------------------
;; Contract: quiz-rewards
;; Purpose: Reward users in STX for correctly answering quiz questions
;; Author: [Your Name]
;; License: MIT
;; --------------------------------------------------

(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_ALREADY_ANSWERED (err u101))
(define-constant ERR_WRONG_ANSWER (err u102))
(define-constant ERR_NO_QUESTION (err u103))
(define-constant ERR_INSUFFICIENT_FUNDS (err u104))

;; === Contract Admin ===
(define-data-var contract-owner principal tx-sender)

;; === Question Store ===
(define-map questions
  uint ;; question ID
  (tuple (answer-hash (buff 32)) (reward uint))
)

;; === Answer Status Tracking ===
(define-map has-answered
  (tuple (user principal) (question-id uint))
  bool
)

;; === Admin: Add a new quiz question ===
(define-public (add-question (question-id uint) (answer-hash (buff 32)) (reward uint))
  (if (is-eq tx-sender (var-get contract-owner))
      (begin
        (map-set questions question-id { answer-hash: answer-hash, reward: reward })
        (ok true))
      ERR_UNAUTHORIZED))

;; === User: Submit an answer to a question ===
(define-public (submit-answer (question-id uint) (user-answer (string-ascii 100)))
  (match (map-get? questions question-id)
    question-data
    (let (
          (already-answered (default-to false (map-get? has-answered { user: tx-sender, question-id: question-id })))
          (hashed-answer (sha256 (unwrap-panic (to-consensus-buff? user-answer))))
          (correct-hash (get answer-hash question-data))
          (reward (get reward question-data))
         )
      (if already-answered
          ERR_ALREADY_ANSWERED
          (if (is-eq hashed-answer correct-hash)
              (begin
                (map-set has-answered { user: tx-sender, question-id: question-id } true)
                (unwrap! (stx-transfer? reward (as-contract tx-sender) tx-sender) ERR_INSUFFICIENT_FUNDS)
                (ok true)
              )
              ERR_WRONG_ANSWER)))
    ERR_NO_QUESTION))

;; === Read-Only: Check if a user has answered a question ===
(define-read-only (check-status (user principal) (question-id uint))
  (ok (default-to false (map-get? has-answered { user: user, question-id: question-id }))))

;; === Read-Only: Get question details (without revealing answer) ===
(define-read-only (get-question-reward (question-id uint))
  (match (map-get? questions question-id)
    question-data (ok (get reward question-data))
    ERR_NO_QUESTION))

;; === Admin: Change contract owner ===
(define-public (change-owner (new-owner principal))
  (if (is-eq tx-sender (var-get contract-owner))
      (begin
        (var-set contract-owner new-owner)
        (ok true))
      ERR_UNAUTHORIZED))

;; === Read-Only: Get current owner ===
(define-read-only (get-owner)
  (ok (var-get contract-owner)))
;; 起動時にスタートアップ画面を表示しない 
(setq inhibit-startup-message t)
;; 1 行ずつスムーズにスクロールする 
(setq scroll-step 1)
;; 言語と文字コード
(set-language-environment 'Japanese)
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
;; 日付の曜日を英語表記
(setq system-time-locale "C")
;; 対応する括弧を光らせる
(show-paren-mode 1)

;; 現在の関数名をモードラインに表示
(which-function-mode 1)

;; タイトルバーに開いているバッファのパスを表示
(setq frame-title-format (format "%%f - Emacs@%s" (system-name)))

;; 行番号の表示。現在の行を強調表示
(global-display-line-numbers-mode)
(set-face-attribute 'line-number nil :foreground "#AAAAAA" :background "#333333")
(set-face-attribute 'line-number-current-line nil :foreground "#FFFFFF")

;; org-modeで行末で折り返しをする
(setq org-startup-truncated nil)

(add-hook 'org-mode-hook
          (lambda ()
            (electric-indent-local-mode -1)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(whiteboard))
 '(org-agenda-files '("~/.my_help/org.org" "/Users/bob/.my_help/todo.org")))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(setq-default ispell-program-name "aspell")
(with-eval-after-load "ispell"
  (setq ispell-local-dictionary "en_US")
  (add-to-list 'ispell-skip-region-alist '("[^\000-\377]+")))
(add-hook 'latex-mode-hook 'flyspell-mode)

;; where I have htmlize.el
(add-to-list 'load-path "~/.emacs.d/site_lisp")
  (require 'htmlize) 

(org-babel-do-load-languages 
'org-babel-load-languages 
'((R . t) 
(emacs-lisp . t) 
(python . t) 
(ruby . t) ))

(add-hook 'ruby-mode-hook
  (lambda () (hs-minor-mode)))

(eval-after-load "hideshow"
  '(add-to-list 'hs-special-modes-alist
    `(ruby-mode
     ,(rx (or "def" "class" "module" "do" "{" "[")) ; Block start
      ,(rx (or "}" "]" "end"))                       ; Block end
      ,(rx (or "#" "=begin"))                        ; Comment start
      ruby-forward-sexp nil)))

(global-set-key (kbd "C-c h") 'hs-hide-block)
(global-set-key (kbd "C-c s") 'hs-show-block)




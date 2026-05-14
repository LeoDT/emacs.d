;;; arlucard.el --- alucard theme from dracula       -*- lexical-binding: t; -*-

;; Copyright (C) 2026  

;; Author:  <leodt@arch>
;; Keywords: 

;;; Code:
(deftheme alucard)


;;;; Configuration options:

(defgroup alucard nil
  "Alucard theme options.

The theme has to be reloaded after changing anything in this group."
  :group 'faces)

(defcustom alucard-enlarge-headings t
  "Use different font sizes for some headings and titles."
  :type 'boolean
  :group 'alucard)

(defcustom alucard-height-title-1 1.3
  "Font size 130%."
  :type 'number
  :group 'alucard)

(defcustom alucard-height-title-2 1.1
  "Font size 110%."
  :type 'number
  :group 'alucard)

(defcustom alucard-height-title-3 1.0
  "Font size 100%."
  :type 'number
  :group 'alucard)

(defcustom alucard-height-doc-title 1.44
  "Font size 144%."
  :type 'number
  :group 'alucard)

(defcustom alucard-alternate-mode-line-and-minibuffer nil
  "Use less bold and pink in the minibuffer."
  :type 'boolean
  :group 'alucard)

(defcustom alucard-bolder-keywords t
  "Use bold weight for syntax faces (keywords, functions, variables)."
  :type 'boolean
  :group 'alucard)

(defvar alucard-use-24-bit-colors-on-256-colors-terms nil
  "Use true colors even on terminals announcing less capabilities.

Beware the use of this variable.  Using it may lead to unwanted
behavior, the most common one being an ugly blue background on
terminals, which don't understand 24 bit colors.  To avoid this
blue background, when using this variable, one can try to add the
following lines in their config file after having load the
Alucard theme:

    (unless (display-graphic-p)
      (set-face-background \\='default \"black\" nil))

There is a lot of discussion behind the 256 colors theme (see URL
`https://github.com/alucard/emacs/pull/57').  Please take time to
read it before opening a new issue about your will.")


;;;; Theme definition:

;; Assigment form: VARIABLE COLOR [256-COLOR [TTY-COLOR]]
(let ((colors '(;; Upstream theme color (Alucard)
                (alucard-bg      "#f5f5f5" "white" "white")           ; background
                (alucard-fg      "#1f1f1f" "black" "black")           ; foreground
                (alucard-current "#cfcfde" "#c6c6c6" "brightblack")   ; current-line/selection
                (alucard-region  "#cfcfde" "#c6c6c6" "brightblack")   ; region
                (alucard-comment "#635d97" "#5f5faf" "blue")          ; comment
                (alucard-cyan    "#036a96" "#0087af" "cyan")          ; cyan
                (alucard-green   "#14710a" "#008700" "green")         ; green
                (alucard-orange  "#a34d14" "#af5f00" "red")           ; orange
                (alucard-pink    "#a3144d" "#af005f" "magenta")       ; pink
                (alucard-purple  "#644ac9" "#5f5faf" "magenta")       ; purple
                (alucard-red     "#b83233" "#af0000" "red")           ; red
                (alucard-yellow  "#846e15" "#af8700" "yellow")        ; yellow
                ;; Other colors (adapted for light background)
                (bg2             "#e4e4e4" "#e4e4e4" "white")
                (bg3             "#d0d0d0" "#d0d0d0" "white")
                (fg2             "#353535" "#444444" "brightblack")
                (fg3             "#555555" "#555555" "brightblack")
                (fg4             "#777777" "#777777" "brightblack")
                (dark-red        "#992222" "#800000" "red")
                (dark-green      "#0e4e07" "#005f00" "green")
                (dark-blue       "#003366" "#005f87" "blue")))
      (faces '(;; default / basic faces
               (cursor :background ,fg3)
               (default :background ,alucard-bg :foreground ,alucard-fg)
               (default-italic :slant italic)
               (error :foreground ,alucard-red)
               (ffap :foreground ,fg4)
               (fringe :background ,alucard-bg :foreground ,fg4)
               (header-line :inherit 'mode-line)
               (highlight :foreground ,fg3 :background ,alucard-current)
               (hl-line :background ,bg2 :extend t)
               (info-quoted-name :foreground ,alucard-orange)
               (info-string :foreground ,alucard-yellow)
               (lazy-highlight :foreground ,fg2 :background ,bg2)
               (link :foreground ,alucard-cyan :underline t)
               (linum :slant italic :foreground ,bg3 :background ,alucard-bg)
               (line-number :slant italic :foreground ,bg3 :background ,alucard-bg)
               (match :background ,alucard-yellow :foreground ,alucard-bg)
               (menu :background ,alucard-current :inverse-video nil
                     ,@(if alucard-alternate-mode-line-and-minibuffer
                           (list :foreground fg3)
                         (list :foreground alucard-fg)))
               (minibuffer-prompt
                ,@(if alucard-alternate-mode-line-and-minibuffer
                      (list :weight 'normal :foreground alucard-fg)
                    (list :weight 'bold :foreground alucard-pink)))
               (mode-line :background ,alucard-current
                          :box ,alucard-current :inverse-video nil
                          ,@(if alucard-alternate-mode-line-and-minibuffer
                                (list :foreground fg3)
                              (list :foreground alucard-fg)))
               (mode-line-inactive
                :background ,alucard-bg :inverse-video nil
                ,@(if alucard-alternate-mode-line-and-minibuffer
                      (list :foreground alucard-comment :box alucard-bg)
                    (list :foreground fg4 :box bg2)))
               (read-multiple-choice-face :inherit completions-first-difference)
               (region :background ,alucard-region :extend nil)
               (shadow :foreground ,alucard-comment)
               (success :foreground ,alucard-green)
               (tooltip :foreground ,alucard-fg :background ,alucard-current)
               (trailing-whitespace :background ,alucard-orange)
               (vertical-border :foreground ,bg2)
               (warning :foreground ,alucard-orange)
               ;; syntax / font-lock
               (font-lock-builtin-face :foreground ,alucard-cyan :slant italic)
               (font-lock-comment-face :inherit shadow)
               (font-lock-comment-delimiter-face :inherit shadow)
               (font-lock-constant-face :foreground ,alucard-purple)
               (font-lock-doc-face :foreground ,alucard-comment)
               (font-lock-function-name-face :foreground ,alucard-green
                                             ,@(when alucard-bolder-keywords
                                                 (list :weight 'bold)))
               (font-lock-keyword-face :foreground ,alucard-pink
                                       ,@(when alucard-bolder-keywords
                                           (list :weight 'bold)))
               (font-lock-negation-char-face :foreground ,alucard-cyan)
               (font-lock-number-face :foreground ,alucard-purple)
               (font-lock-operator-face :foreground ,alucard-pink)
               (font-lock-preprocessor-face :foreground ,alucard-orange)
               (font-lock-reference-face :inherit font-lock-constant-face) ;; obsolete
               (font-lock-regexp-grouping-backslash :foreground ,alucard-cyan)
               (font-lock-regexp-grouping-construct :foreground ,alucard-purple)
               (font-lock-string-face :foreground ,alucard-yellow)
               (font-lock-type-face :inherit font-lock-builtin-face)
               (font-lock-variable-name-face :foreground ,alucard-fg
                                             ,@(when alucard-bolder-keywords
                                                 (list :weight 'bold)))
               (font-lock-warning-face :inherit warning :background ,bg2)
               ;; auto-complete
               (ac-completion-face :underline t :foreground ,alucard-pink)
               ;; ansi-color
               (ansi-color-black :foreground ,alucard-bg :background ,alucard-bg)
               (ansi-color-bright-black :foreground "black" :background "black")
               (ansi-color-blue :foreground ,alucard-purple :background ,alucard-purple)
               (ansi-color-bright-blue :foreground ,alucard-purple
                                       :background ,alucard-purple
                                       :weight bold)
               (ansi-color-cyan :foreground ,alucard-cyan :background ,alucard-cyan)
               (ansi-color-bright-cyan :foreground ,alucard-cyan
                                       :background ,alucard-cyan
                                       :weight bold)
               (ansi-color-green :foreground ,alucard-green :background ,alucard-green)
               (ansi-color-bright-green :foreground ,alucard-green
                                        :background ,alucard-green
                                        :weight bold)
               (ansi-color-magenta :foreground ,alucard-pink :background ,alucard-pink)
               (ansi-color-bright-magenta :foreground ,alucard-pink
                                          :background ,alucard-pink
                                          :weight bold)
               (ansi-color-red :foreground ,alucard-red :background ,alucard-red)
               (ansi-color-bright-red :foreground ,alucard-red
                                      :background ,alucard-red
                                      :weight bold)
               (ansi-color-white :foreground ,alucard-fg :background ,alucard-fg)
               (ansi-color-bright-white :foreground "white" :background "white")
               (ansi-color-yellow :foreground ,alucard-yellow :background ,alucard-yellow)
               (ansi-color-bright-yellow :foreground ,alucard-yellow
                                         :background ,alucard-yellow
                                         :weight bold)
               ;; bookmarks
               (bookmark-face :foreground ,alucard-pink)
               ;; company
               (company-echo-common :foreground ,alucard-bg :background ,alucard-fg)
               (company-preview :background ,alucard-current :foreground ,dark-blue)
               (company-preview-common :inherit company-preview
                                       :foreground ,alucard-pink)
               (company-preview-search :inherit company-preview
                                       :foreground ,alucard-green)
               (company-scrollbar-bg :background ,alucard-comment)
               (company-scrollbar-fg :foreground ,dark-blue)
               (company-tooltip :inherit tooltip)
               (company-tooltip-search :foreground ,alucard-green
                                       :underline t)
               (company-tooltip-search-selection :background ,alucard-green
                                                 :foreground ,alucard-bg)
               (company-tooltip-selection :inherit match)
               (company-tooltip-mouse :background ,alucard-bg)
               (company-tooltip-common :foreground ,alucard-pink :weight bold)
               ;;(company-tooltip-common-selection :inherit company-tooltip-common)
               (company-tooltip-annotation :foreground ,alucard-cyan)
               ;;(company-tooltip-annotation-selection :inherit company-tooltip-annotation)
               ;; completions (minibuffer.el)
               (completions-annotations :inherit font-lock-comment-face)
               (completions-common-part :foreground ,alucard-green)
               (completions-first-difference :foreground ,alucard-pink :weight bold)
               ;; diff
               (diff-added :background ,dark-green :foreground ,alucard-fg :extend t)
               (diff-removed :background ,dark-red :foreground ,alucard-fg :extend t)
               (diff-refine-added :background ,alucard-green
                                  :foreground ,alucard-bg)
               (diff-refine-removed :background ,alucard-red
                                    :foreground ,alucard-fg)
               (diff-indicator-added :foreground ,alucard-green)
               (diff-indicator-removed :foreground ,alucard-red)
               (diff-indicator-changed :foreground ,alucard-orange)
               (diff-error :foreground ,alucard-red, :background ,alucard-bg
                           :weight bold)
               ;; diff-hl
               (diff-hl-change :foreground ,alucard-orange :background ,alucard-orange)
               (diff-hl-delete :foreground ,alucard-red :background ,alucard-red)
               (diff-hl-insert :foreground ,alucard-green :background ,alucard-green)
               ;; dired
               (dired-directory :foreground ,alucard-green :weight normal)
               (dired-flagged :foreground ,alucard-pink)
               (dired-header :foreground ,fg3 :background ,alucard-bg)
               (dired-ignored :inherit shadow)
               (dired-mark :foreground ,alucard-fg :weight bold)
               (dired-marked :foreground ,alucard-orange :weight bold)
               (dired-perm-write :foreground ,fg3 :underline t)
               (dired-symlink :foreground ,alucard-yellow :weight normal :slant italic)
               (dired-warning :foreground ,alucard-orange :underline t)
               (diredp-compressed-file-name :foreground ,fg3)
               (diredp-compressed-file-suffix :foreground ,fg4)
               (diredp-date-time :foreground ,alucard-fg)
               (diredp-deletion-file-name :foreground ,alucard-pink :background ,alucard-current)
               (diredp-deletion :foreground ,alucard-pink :weight bold)
               (diredp-dir-heading :foreground ,fg2 :background ,bg3)
               (diredp-dir-name :inherit dired-directory)
               (diredp-dir-priv :inherit dired-directory)
               (diredp-executable-tag :foreground ,alucard-orange)
               (diredp-file-name :foreground ,alucard-fg)
               (diredp-file-suffix :foreground ,fg4)
               (diredp-flag-mark-line :foreground ,fg2 :slant italic :background ,alucard-current)
               (diredp-flag-mark :foreground ,fg2 :weight bold :background ,alucard-current)
               (diredp-ignored-file-name :foreground ,alucard-fg)
               (diredp-mode-line-flagged :foreground ,alucard-orange)
               (diredp-mode-line-marked :foreground ,alucard-orange)
               (diredp-no-priv :foreground ,alucard-fg)
               (diredp-number :foreground ,alucard-cyan)
               (diredp-other-priv :foreground ,alucard-orange)
               (diredp-rare-priv :foreground ,alucard-orange)
               (diredp-read-priv :foreground ,alucard-purple)
               (diredp-write-priv :foreground ,alucard-pink)
               (diredp-exec-priv :foreground ,alucard-yellow)
               (diredp-symlink :foreground ,alucard-orange)
               (diredp-link-priv :foreground ,alucard-orange)
               (diredp-autofile-name :foreground ,alucard-yellow)
               (diredp-tagged-autofile-name :foreground ,alucard-yellow)
               ;; ediff
               (ediff-current-diff-A :background ,dark-red)
               (ediff-fine-diff-A :background ,alucard-red :foreground ,alucard-fg)
               (ediff-current-diff-B :background ,dark-green)
               (ediff-fine-diff-B :background ,alucard-green :foreground ,alucard-bg)
               (ediff-current-diff-C :background ,dark-blue)
               (ediff-fine-diff-C :background ,alucard-cyan :foreground ,alucard-bg)
               ;; eglot
               (eglot-diagnostic-tag-unnecessary-face :inherit warning)
               (eglot-diagnostic-tag-deprecated-face :inherit warning :strike-through t)
               ;; eldoc-box
               (eldoc-box-border :background ,alucard-current)
               (eldoc-box-body :background ,alucard-current)
               ;; elfeed
               (elfeed-search-date-face :foreground ,alucard-comment)
               (elfeed-search-title-face :foreground ,alucard-fg)
               (elfeed-search-unread-title-face :foreground ,alucard-pink :weight bold)
               (elfeed-search-feed-face :foreground ,alucard-fg :weight bold)
               (elfeed-search-tag-face :foreground ,alucard-green)
               (elfeed-search-last-update-face :weight bold)
               (elfeed-search-unread-count-face :foreground ,alucard-pink)
               (elfeed-search-filter-face :foreground ,alucard-green :weight bold)
               ;;(elfeed-log-date-face :inherit font-lock-type-face)
               (elfeed-log-error-level-face :foreground ,alucard-red)
               (elfeed-log-warn-level-face :foreground ,alucard-orange)
               (elfeed-log-info-level-face :foreground ,alucard-cyan)
               (elfeed-log-debug-level-face :foreground ,alucard-comment)
               ;; elpher
               (elpher-gemini-heading1 :inherit bold :foreground ,alucard-pink
                                       ,@(when alucard-enlarge-headings
                                           (list :height alucard-height-title-1)))
               (elpher-gemini-heading2 :inherit bold :foreground ,alucard-purple
                                       ,@(when alucard-enlarge-headings
                                           (list :height alucard-height-title-2)))
               (elpher-gemini-heading3 :weight normal :foreground ,alucard-green
                                       ,@(when alucard-enlarge-headings
                                           (list :height alucard-height-title-3)))
               (elpher-gemini-preformatted :inherit fixed-pitch
                                           :foreground ,alucard-orange)
               ;; enh-ruby
               (enh-ruby-heredoc-delimiter-face :foreground ,alucard-yellow)
               (enh-ruby-op-face :foreground ,alucard-pink)
               (enh-ruby-regexp-delimiter-face :foreground ,alucard-yellow)
               (enh-ruby-string-delimiter-face :foreground ,alucard-yellow)
               ;; flyspell
               (flyspell-duplicate :underline (:style wave :color ,alucard-orange))
               (flyspell-incorrect :underline (:style wave :color ,alucard-red))
               ;; font-latex (auctex)
               (font-latex-bold-face :foreground ,alucard-purple)
               (font-latex-italic-face :foreground ,alucard-pink :slant italic)
               (font-latex-match-reference-keywords :foreground ,alucard-cyan)
               (font-latex-match-variable-keywords :foreground ,alucard-fg)
               (font-latex-math-face :foreground ,alucard-orange)
               (font-latex-script-char-face :inherit font-latex-math-face)
               (font-latex-sectioning-0-face :foreground ,alucard-pink :weight bold
                                             ,@(when alucard-enlarge-headings
                                                 (list :height alucard-height-title-1)))
               (font-latex-sectioning-1-face :foreground ,alucard-purple :weight bold
                                             ,@(when alucard-enlarge-headings
                                                 (list :height alucard-height-title-1)))
               (font-latex-sectioning-2-face :foreground ,alucard-green :weight bold
                                             ,@(when alucard-enlarge-headings
                                                 (list :height alucard-height-title-2)))
               (font-latex-sectioning-3-face :foreground ,alucard-yellow :weight bold
                                             ,@(when alucard-enlarge-headings
                                                 (list :height alucard-height-title-3)))
               (font-latex-sectioning-4-face :foreground ,alucard-cyan :weight bold)
               (font-latex-sectioning-5-face :foreground ,alucard-orange :weight bold)
               (font-latex-sedate-face :foreground ,alucard-pink)
               (font-latex-string-face :foreground ,alucard-yellow)
               (font-latex-verbatim-face :foreground ,alucard-orange)
               (font-latex-warning-face :foreground ,alucard-red)
               ;; gemini
               (gemini-heading-face-1 :inherit bold :foreground ,alucard-pink
                                      ,@(when alucard-enlarge-headings
                                          (list :height alucard-height-title-1)))
               (gemini-heading-face-2 :inherit bold :foreground ,alucard-purple
                                      ,@(when alucard-enlarge-headings
                                          (list :height alucard-height-title-2)))
               (gemini-heading-face-3 :weight normal :foreground ,alucard-green
                                      ,@(when alucard-enlarge-headings
                                          (list :height alucard-height-title-3)))
               (gemini-heading-face-rest :weight normal :foreground ,alucard-yellow)
               (gemini-quote-face :foreground ,alucard-purple)
               ;; go-test
               (go-test--ok-face :inherit success)
               (go-test--error-face :inherit error)
               (go-test--warning-face :inherit warning)
               (go-test--pointer-face :foreground ,alucard-pink)
               (go-test--standard-face :foreground ,alucard-cyan)
               ;; gnus-group
               (gnus-group-mail-1 :foreground ,alucard-pink :weight bold)
               (gnus-group-mail-1-empty :inherit gnus-group-mail-1 :weight normal)
               (gnus-group-mail-2 :foreground ,alucard-cyan :weight bold)
               (gnus-group-mail-2-empty :inherit gnus-group-mail-2 :weight normal)
               (gnus-group-mail-3 :foreground ,alucard-comment :weight bold)
               (gnus-group-mail-3-empty :inherit gnus-group-mail-3 :weight normal)
               (gnus-group-mail-low :foreground ,alucard-current :weight bold)
               (gnus-group-mail-low-empty :inherit gnus-group-mail-low :weight normal)
               (gnus-group-news-1 :foreground ,alucard-pink :weight bold)
               (gnus-group-news-1-empty :inherit gnus-group-news-1 :weight normal)
               (gnus-group-news-2 :foreground ,alucard-cyan :weight bold)
               (gnus-group-news-2-empty :inherit gnus-group-news-2 :weight normal)
               (gnus-group-news-3 :foreground ,alucard-comment :weight bold)
               (gnus-group-news-3-empty :inherit gnus-group-news-3 :weight normal)
               (gnus-group-news-4 :inherit gnus-group-news-low)
               (gnus-group-news-4-empty :inherit gnus-group-news-low-empty)
               (gnus-group-news-5 :inherit gnus-group-news-low)
               (gnus-group-news-5-empty :inherit gnus-group-news-low-empty)
               (gnus-group-news-6 :inherit gnus-group-news-low)
               (gnus-group-news-6-empty :inherit gnus-group-news-low-empty)
               (gnus-group-news-low :foreground ,alucard-current :weight bold)
               (gnus-group-news-low-empty :inherit gnus-group-news-low :weight normal)
               (gnus-header-content :foreground ,alucard-purple)
               (gnus-header-from :foreground ,alucard-fg)
               (gnus-header-name :foreground ,alucard-green)
               (gnus-header-subject :foreground ,alucard-pink :weight bold)
               (gnus-summary-markup-face :foreground ,alucard-cyan)
               (gnus-summary-high-unread :foreground ,alucard-pink :weight bold)
               (gnus-summary-high-read :inherit gnus-summary-high-unread :weight normal)
               (gnus-summary-high-ancient :inherit gnus-summary-high-read)
               (gnus-summary-high-ticked :inherit gnus-summary-high-read :underline t)
               (gnus-summary-normal-unread :foreground ,dark-blue :weight bold)
               (gnus-summary-normal-read :foreground ,alucard-comment :weight normal)
               (gnus-summary-normal-ancient :inherit gnus-summary-normal-read :weight light)
               (gnus-summary-normal-ticked :foreground ,alucard-pink :weight bold)
               (gnus-summary-low-unread :foreground ,alucard-comment :weight bold)
               (gnus-summary-low-read :inherit gnus-summary-low-unread :weight normal)
               (gnus-summary-low-ancient :inherit gnus-summary-low-read)
               (gnus-summary-low-ticked :inherit gnus-summary-low-read :underline t)
               (gnus-summary-selected :inverse-video t)
               ;; haskell-mode
               (haskell-operator-face :foreground ,alucard-pink)
               (haskell-constructor-face :foreground ,alucard-purple)
               ;; helm
               (helm-bookmark-w3m :foreground ,alucard-purple)
               (helm-buffer-not-saved :foreground ,alucard-purple :background ,alucard-bg)
               (helm-buffer-process :foreground ,alucard-orange :background ,alucard-bg)
               (helm-buffer-saved-out :foreground ,alucard-fg :background ,alucard-bg)
               (helm-buffer-size :foreground ,alucard-fg :background ,alucard-bg)
               (helm-candidate-number :foreground ,alucard-bg :background ,alucard-fg)
               (helm-ff-directory :foreground ,alucard-green :background ,alucard-bg :weight bold)
               (helm-ff-dotted-directory :foreground ,alucard-green :background ,alucard-bg :weight normal)
               (helm-ff-executable :foreground ,dark-blue :background ,alucard-bg :weight normal)
               (helm-ff-file :foreground ,alucard-fg :background ,alucard-bg :weight normal)
               (helm-ff-invalid-symlink :foreground ,alucard-pink :background ,alucard-bg :weight bold)
               (helm-ff-prefix :foreground ,alucard-bg :background ,alucard-pink :weight normal)
               (helm-ff-symlink :foreground ,alucard-pink :background ,alucard-bg :weight bold)
               (helm-grep-cmd-line :foreground ,alucard-fg :background ,alucard-bg)
               (helm-grep-file :foreground ,alucard-fg :background ,alucard-bg)
               (helm-grep-finish :foreground ,fg2 :background ,alucard-bg)
               (helm-grep-lineno :foreground ,alucard-fg :background ,alucard-bg)
               (helm-grep-match :inherit match)
               (helm-grep-running :foreground ,alucard-green :background ,alucard-bg)
               (helm-header :foreground ,fg2 :background ,alucard-bg :underline nil :box nil)
               (helm-moccur-buffer :foreground ,alucard-green :background ,alucard-bg)
               (helm-selection :background ,bg2 :underline nil)
               (helm-selection-line :background ,bg2)
               (helm-separator :foreground ,alucard-purple :background ,alucard-bg)
               (helm-source-go-package-godoc-description :foreground ,alucard-yellow)
               (helm-source-header :foreground ,alucard-pink :background ,alucard-bg :underline nil :weight bold)
               (helm-time-zone-current :foreground ,alucard-orange :background ,alucard-bg)
               (helm-time-zone-home :foreground ,alucard-purple :background ,alucard-bg)
               (helm-visible-mark :foreground ,alucard-bg :background ,alucard-current)
               ;; highlight-indentation minor mode
               (highlight-indentation-face :background ,bg2)
               ;; icicle
               (icicle-whitespace-highlight :background ,alucard-fg)
               (icicle-special-candidate :foreground ,fg2)
               (icicle-extra-candidate :foreground ,fg2)
               (icicle-search-main-regexp-others :foreground ,alucard-fg)
               (icicle-search-current-input :foreground ,alucard-pink)
               (icicle-search-context-level-8 :foreground ,alucard-orange)
               (icicle-search-context-level-7 :foreground ,alucard-orange)
               (icicle-search-context-level-6 :foreground ,alucard-orange)
               (icicle-search-context-level-5 :foreground ,alucard-orange)
               (icicle-search-context-level-4 :foreground ,alucard-orange)
               (icicle-search-context-level-3 :foreground ,alucard-orange)
               (icicle-search-context-level-2 :foreground ,alucard-orange)
               (icicle-search-context-level-1 :foreground ,alucard-orange)
               (icicle-search-main-regexp-current :foreground ,alucard-fg)
               (icicle-saved-candidate :foreground ,alucard-fg)
               (icicle-proxy-candidate :foreground ,alucard-fg)
               (icicle-mustmatch-completion :foreground ,alucard-purple)
               (icicle-multi-command-completion :foreground ,fg2 :background ,bg2)
               (icicle-msg-emphasis :foreground ,alucard-green)
               (icicle-mode-line-help :foreground ,fg4)
               (icicle-match-highlight-minibuffer :foreground ,alucard-orange)
               (icicle-match-highlight-Completions :foreground ,alucard-green)
               (icicle-key-complete-menu-local :foreground ,alucard-fg)
               (icicle-key-complete-menu :foreground ,alucard-fg)
               (icicle-input-completion-fail-lax :foreground ,alucard-pink)
               (icicle-input-completion-fail :foreground ,alucard-pink)
               (icicle-historical-candidate-other :foreground ,alucard-fg)
               (icicle-historical-candidate :foreground ,alucard-fg)
               (icicle-current-candidate-highlight :foreground ,alucard-orange :background ,alucard-current)
               (icicle-Completions-instruction-2 :foreground ,fg4)
               (icicle-Completions-instruction-1 :foreground ,fg4)
               (icicle-completion :foreground ,alucard-fg)
               (icicle-complete-input :foreground ,alucard-orange)
               (icicle-common-match-highlight-Completions :foreground ,alucard-purple)
               (icicle-candidate-part :foreground ,alucard-fg)
               (icicle-annotation :foreground ,fg4)
               ;; icomplete
               (icompletep-determined :foreground ,alucard-orange)
               ;; ido
               (ido-first-match
                ,@(if alucard-alternate-mode-line-and-minibuffer
                      (list :weight 'normal :foreground alucard-green)
                    (list :weight 'bold :foreground alucard-pink)))
               (ido-only-match :foreground ,alucard-orange)
               (ido-subdir :foreground ,alucard-yellow)
               (ido-virtual :foreground ,alucard-cyan)
               (ido-incomplete-regexp :inherit font-lock-warning-face)
               (ido-indicator :foreground ,alucard-fg :background ,alucard-pink)
               ;; imenu-list
               (imenu-list-entry-face-0 :foreground ,alucard-pink)
               (imenu-list-entry-face-1 :foreground ,alucard-purple)
               (imenu-list-entry-face-2 :foreground ,alucard-green)
               (imenu-list-entry-face-3 :foreground ,alucard-yellow)
               (imenu-list-entry-subalist-face-0 :inherit imenu-list-entry-face-0
                                                 :weight bold :underline t
                                                 ,@(when alucard-enlarge-headings
                                                     (list :height alucard-height-title-1)))
               (imenu-list-entry-subalist-face-1 :inherit imenu-list-entry-face-1
                                                 :weight bold :underline t
                                                 ,@(when alucard-enlarge-headings
                                                     (list :height alucard-height-title-2)))
               (imenu-list-entry-subalist-face-2 :inherit imenu-list-entry-face-2
                                                 :weight bold :underline t
                                                 ,@(when alucard-enlarge-headings
                                                     (list :height alucard-height-title-3)))
               (imenu-list-entry-subalist-face-3 :inherit imenu-list-entry-face-3
                                                 :weight bold :underline t)
               ;; ivy
               (ivy-current-match
                ,@(if alucard-alternate-mode-line-and-minibuffer
                      (list :background alucard-current
                            :foreground alucard-green
                            :weight 'normal)
                    (list :background alucard-current
                          :foreground alucard-pink
                          :weight 'bold)))
               ;; Highlights the background of the match.
               (ivy-minibuffer-match-face-1 :background ,alucard-current)
               ;; Highlights the first matched group.
               (ivy-minibuffer-match-face-2 :background ,alucard-green
                                            :foreground ,alucard-bg)
               ;; Highlights the second matched group.
               (ivy-minibuffer-match-face-3 :background ,alucard-yellow
                                            :foreground ,alucard-bg)
               ;; Highlights the third matched group.
               (ivy-minibuffer-match-face-4 :background ,alucard-pink
                                            :foreground ,alucard-bg)
               (ivy-confirm-face :foreground ,alucard-orange)
               (ivy-match-required-face :foreground ,alucard-red)
               (ivy-subdir :foreground ,alucard-yellow)
               (ivy-remote :foreground ,alucard-pink)
               (ivy-virtual :foreground ,alucard-cyan)
               ;; isearch
               (isearch :inherit match :weight bold)
               (isearch-fail :foreground ,alucard-bg :background ,alucard-orange)
               ;; jde-java
               (jde-java-font-lock-constant-face :foreground ,alucard-cyan)
               (jde-java-font-lock-modifier-face :foreground ,alucard-pink)
               (jde-java-font-lock-number-face :foreground ,alucard-fg)
               (jde-java-font-lock-package-face :foreground ,alucard-fg)
               (jde-java-font-lock-private-face :foreground ,alucard-pink)
               (jde-java-font-lock-public-face :foreground ,alucard-pink)
               ;; js2-mode
               (js2-external-variable :foreground ,alucard-purple)
               (js2-function-param :foreground ,alucard-cyan)
               (js2-jsdoc-html-tag-delimiter :foreground ,alucard-yellow)
               (js2-jsdoc-html-tag-name :foreground ,dark-blue)
               (js2-jsdoc-value :foreground ,alucard-yellow)
               (js2-private-function-call :foreground ,alucard-cyan)
               (js2-private-member :foreground ,fg3)
               ;; js3-mode
               (js3-error-face :underline ,alucard-orange)
               (js3-external-variable-face :foreground ,alucard-fg)
               (js3-function-param-face :foreground ,alucard-pink)
               (js3-instance-member-face :foreground ,alucard-cyan)
               (js3-jsdoc-tag-face :foreground ,alucard-pink)
               (js3-warning-face :underline ,alucard-pink)
               ;; lsp
               (lsp-ui-peek-peek :background ,alucard-bg)
               (lsp-ui-peek-list :background ,bg2)
               (lsp-ui-peek-filename :foreground ,alucard-pink :weight bold)
               (lsp-ui-peek-line-number :foreground ,alucard-fg)
               (lsp-ui-peek-highlight :inherit highlight :distant-foreground ,alucard-bg)
               (lsp-ui-peek-header :background ,alucard-current :foreground ,fg3, :weight bold)
               (lsp-ui-peek-footer :inherit lsp-ui-peek-header)
               (lsp-ui-peek-selection :inherit match)
               (lsp-ui-sideline-symbol :foreground ,fg4 :box (:line-width -1 :color ,fg4) :height 0.99)
               (lsp-ui-sideline-current-symbol :foreground ,alucard-fg :weight ultra-bold
                                               :box (:line-width -1 :color ,alucard-fg) :height 0.99)
               (lsp-ui-sideline-code-action :foreground ,alucard-yellow)
               (lsp-ui-sideline-symbol-info :slant italic :height 0.99)
               (lsp-ui-doc-background :background ,alucard-bg)
               (lsp-ui-doc-header :foreground ,alucard-bg :background ,alucard-cyan)
               ;; magit
               (magit-branch-local :foreground ,alucard-cyan)
               (magit-branch-remote :foreground ,alucard-green)
               (magit-refname :foreground ,dark-blue)
               (magit-tag :foreground ,alucard-orange)
               (magit-hash :foreground ,alucard-comment)
               (magit-dimmed :foreground ,alucard-comment)
               (magit-section-heading :foreground ,alucard-pink :weight bold)
               (magit-section-highlight :background ,alucard-current :extend t)
               (magit-diff-context :foreground ,fg3 :extend t)
               (magit-diff-context-highlight :inherit magit-section-highlight
                                             :foreground ,alucard-fg)
               (magit-diff-revision-summary :foreground ,alucard-orange
                                            :background ,alucard-bg
                                            :weight bold)
               (magit-diff-revision-summary-highlight :inherit magit-section-highlight
                                                      :foreground ,alucard-orange
                                                      :weight bold)
               (magit-diff-added :background ,alucard-bg :foreground ,alucard-green)
               (magit-diff-added-highlight :background ,alucard-current
                                           :foreground ,alucard-green)
               (magit-diff-removed :background ,alucard-bg :foreground ,alucard-red)
               (magit-diff-removed-highlight :background ,alucard-current
                                             :foreground ,alucard-red)
               (magit-diff-file-heading :foreground ,alucard-fg)
               (magit-diff-file-heading-highlight :inherit magit-section-highlight
                                                  :weight bold)
               (magit-diff-file-heading-selection
                :inherit magit-diff-file-heading-highlight
                :foreground ,alucard-pink)
               (magit-diff-hunk-heading :inherit magit-diff-context
                                        :background ,bg3)
               (magit-diff-hunk-heading-highlight
                :inherit magit-diff-context-highlight
                :weight bold)
               (magit-diff-hunk-heading-selection
                :inherit magit-diff-hunk-heading-highlight
                :foreground ,alucard-pink)
               (magit-diff-lines-heading
                :inherit magit-diff-hunk-heading-highlight
                :foreground ,alucard-pink)
               (magit-diff-lines-boundary :background ,alucard-pink)
               (magit-diffstat-added :foreground ,alucard-green)
               (magit-diffstat-removed :foreground ,alucard-red)
               (magit-log-author :foreground ,alucard-comment)
               (magit-log-date :foreground ,alucard-comment)
               (magit-log-graph :foreground ,alucard-yellow)
               (magit-process-ng :foreground ,alucard-orange :weight bold)
               (magit-process-ok :foreground ,alucard-green :weight bold)
               (magit-signature-good :foreground ,alucard-green)
               (magit-signature-bad :foreground ,alucard-red :weight bold)
               (magit-signature-untrusted :foreground ,alucard-cyan)
               (magit-signature-expired :foreground ,alucard-orange)
               (magit-signature-revoked :foreground ,alucard-purple)
               (magit-signature-error :foreground ,alucard-cyan)
               (magit-cherry-unmatched :foreground ,alucard-cyan)
               (magit-cherry-equivalent :foreground ,alucard-purple)
               ;; markdown
               (markdown-blockquote-face :foreground ,alucard-yellow
                                         :slant italic)
               (markdown-code-face :foreground ,alucard-orange)
               (markdown-footnote-face :foreground ,dark-blue)
               (markdown-header-face :weight normal)
               (markdown-header-face-1
                :inherit bold :foreground ,alucard-pink
                ,@(when alucard-enlarge-headings
                    (list :height alucard-height-title-1)))
               (markdown-header-face-2
                :inherit bold :foreground ,alucard-purple
                ,@(when alucard-enlarge-headings
                    (list :height alucard-height-title-2)))
               (markdown-header-face-3
                :foreground ,alucard-green
                ,@(when alucard-enlarge-headings
                    (list :height alucard-height-title-3)))
               (markdown-header-face-4 :foreground ,alucard-yellow)
               (markdown-header-face-5 :foreground ,alucard-cyan)
               (markdown-header-face-6 :foreground ,alucard-orange)
               (markdown-header-face-7 :foreground ,dark-blue)
               (markdown-header-face-8 :foreground ,alucard-fg)
               (markdown-inline-code-face :foreground ,alucard-green)
               (markdown-plain-url-face :inherit link)
               (markdown-pre-face :foreground ,alucard-orange)
               (markdown-table-face :foreground ,alucard-purple)
               (markdown-list-face :foreground ,alucard-cyan)
               (markdown-language-keyword-face :foreground ,alucard-comment)
               ;; message
               (message-header-to :foreground ,alucard-fg :weight bold)
               (message-header-cc :foreground ,alucard-fg :bold bold)
               (message-header-subject :foreground ,alucard-orange)
               (message-header-newsgroups :foreground ,alucard-purple)
               (message-header-other :foreground ,alucard-purple)
               (message-header-name :foreground ,alucard-green)
               (message-header-xheader :foreground ,alucard-cyan)
               (message-separator :foreground ,alucard-cyan :slant italic)
               (message-cited-text :foreground ,alucard-purple)
               (message-cited-text-1 :foreground ,alucard-purple)
               (message-cited-text-2 :foreground ,alucard-orange)
               (message-cited-text-3 :foreground ,alucard-comment)
               (message-cited-text-4 :foreground ,fg2)
               (message-mml :foreground ,alucard-green :weight normal)
               ;; mini-modeline
               (mini-modeline-mode-line :inherit mode-line :height 0.1 :box nil)
               ;; mu4e
               (mu4e-unread-face :foreground ,alucard-pink :weight normal)
               (mu4e-view-url-number-face :foreground ,alucard-purple)
               (mu4e-highlight-face :background ,alucard-bg
                                    :foreground ,alucard-yellow
                                    :extend t)
               (mu4e-header-highlight-face :background ,alucard-current
                                           :foreground ,alucard-fg
                                           :underline nil :weight bold
                                           :extend t)
               (mu4e-header-key-face :inherit message-mml)
               (mu4e-header-marks-face :foreground ,alucard-purple)
               (mu4e-cited-1-face :foreground ,alucard-purple)
               (mu4e-cited-2-face :foreground ,alucard-orange)
               (mu4e-cited-3-face :foreground ,alucard-comment)
               (mu4e-cited-4-face :foreground ,fg2)
               (mu4e-cited-5-face :foreground ,fg3)
               ;; neotree
               (neo-banner-face :foreground ,alucard-orange :weight bold)
               ;;(neo-button-face :underline nil)
               (neo-dir-link-face :foreground ,alucard-purple)
               (neo-expand-btn-face :foreground ,alucard-fg)
               (neo-file-link-face :foreground ,alucard-cyan)
               (neo-header-face :background ,alucard-bg
                                :foreground ,alucard-fg
                                :weight bold)
               (neo-root-dir-face :foreground ,alucard-purple :weight bold)
               (neo-vc-added-face :foreground ,alucard-orange)
               (neo-vc-conflict-face :foreground ,alucard-red)
               (neo-vc-default-face :inherit neo-file-link-face)
               (neo-vc-edited-face :foreground ,alucard-orange)
               (neo-vc-ignored-face :foreground ,alucard-comment)
               (neo-vc-missing-face :foreground ,alucard-red)
               (neo-vc-needs-merge-face :foreground ,alucard-red
                                        :weight bold)
               ;;(neo-vc-needs-update-face :underline t)
               ;;(neo-vc-removed-face :strike-through t)
               (neo-vc-unlocked-changes-face :foreground ,alucard-red)
               ;;(neo-vc-unregistered-face nil)
               (neo-vc-up-to-date-face :foreground ,alucard-green)
               (neo-vc-user-face :foreground ,alucard-purple)
               ;; org
               (org-agenda-date :foreground ,alucard-cyan :underline nil)
               (org-agenda-dimmed-todo-face :foreground ,alucard-comment)
               (org-agenda-done :foreground ,alucard-green)
               (org-agenda-structure :foreground ,alucard-purple)
               (org-block :foreground ,alucard-orange)
               (org-code :foreground ,alucard-green)
               (org-column :background ,bg3)
               (org-column-title :inherit org-column :weight bold :underline t)
               (org-date :foreground ,alucard-cyan :underline t)
               (org-document-info :foreground ,dark-blue)
               (org-document-info-keyword :foreground ,alucard-comment)
               (org-document-title :weight bold :foreground ,alucard-orange
                                   ,@(when alucard-enlarge-headings
                                       (list :height alucard-height-doc-title)))
               (org-done :foreground ,alucard-green)
               (org-ellipsis :foreground ,alucard-comment)
               (org-footnote :foreground ,dark-blue)
               (org-formula :foreground ,alucard-pink)
               (org-headline-done :foreground ,alucard-comment
                                  :weight normal :strike-through t)
               (org-hide :foreground ,alucard-bg :background ,alucard-bg)
               (org-level-1 :inherit bold :foreground ,alucard-pink
                            ,@(when alucard-enlarge-headings
                                (list :height alucard-height-title-1)))
               (org-level-2 :inherit bold :foreground ,alucard-purple
                            ,@(when alucard-enlarge-headings
                                (list :height alucard-height-title-2)))
               (org-level-3 :weight normal :foreground ,alucard-green
                            ,@(when alucard-enlarge-headings
                                (list :height alucard-height-title-3)))
               (org-level-4 :weight normal :foreground ,alucard-yellow)
               (org-level-5 :weight normal :foreground ,alucard-cyan)
               (org-level-6 :weight normal :foreground ,alucard-orange)
               (org-level-7 :weight normal :foreground ,dark-blue)
               (org-level-8 :weight normal :foreground ,alucard-fg)
               (org-link :foreground ,alucard-cyan :underline t)
               (org-priority :foreground ,alucard-cyan)
               (org-quote :foreground ,alucard-yellow :slant italic)
               (org-scheduled :foreground ,alucard-green)
               (org-scheduled-previously :foreground ,alucard-yellow)
               (org-scheduled-today :foreground ,alucard-green)
               (org-sexp-date :foreground ,fg4)
               (org-special-keyword :foreground ,alucard-yellow)
               (org-table :foreground ,alucard-purple)
               (org-tag :foreground ,alucard-pink :weight bold :background ,bg2)
               (org-todo :foreground ,alucard-orange :weight bold :background ,bg2)
               (org-upcoming-deadline :foreground ,alucard-yellow)
               (org-verbatim :inherit org-quote)
               (org-warning :weight bold :foreground ,alucard-pink)
               ;; outline
               (outline-1 :foreground ,alucard-pink)
               (outline-2 :foreground ,alucard-purple)
               (outline-3 :foreground ,alucard-green)
               (outline-4 :foreground ,alucard-yellow)
               (outline-5 :foreground ,alucard-cyan)
               (outline-6 :foreground ,alucard-orange)
               ;; perspective
               (persp-selected-face :weight bold :foreground ,alucard-pink)
               ;; powerline
               (powerline-active1 :background ,alucard-bg :foreground ,alucard-pink)
               (powerline-active2 :background ,alucard-bg :foreground ,alucard-pink)
               (powerline-inactive1 :background ,bg2 :foreground ,alucard-purple)
               (powerline-inactive2 :background ,bg2 :foreground ,alucard-purple)
               (powerline-evil-base-face :foreground ,bg2)
               (powerline-evil-emacs-face :inherit powerline-evil-base-face :background ,alucard-yellow)
               (powerline-evil-insert-face :inherit powerline-evil-base-face :background ,alucard-cyan)
               (powerline-evil-motion-face :inherit powerline-evil-base-face :background ,alucard-purple)
               (powerline-evil-normal-face :inherit powerline-evil-base-face :background ,alucard-green)
               (powerline-evil-operator-face :inherit powerline-evil-base-face :background ,alucard-pink)
               (powerline-evil-replace-face :inherit powerline-evil-base-face :background ,alucard-red)
               (powerline-evil-visual-face :inherit powerline-evil-base-face :background ,alucard-orange)
               ;; rainbow-delimiters
               (rainbow-delimiters-depth-1-face :foreground ,alucard-fg)
               (rainbow-delimiters-depth-2-face :foreground ,alucard-cyan)
               (rainbow-delimiters-depth-3-face :foreground ,alucard-purple)
               (rainbow-delimiters-depth-4-face :foreground ,alucard-pink)
               (rainbow-delimiters-depth-5-face :foreground ,alucard-orange)
               (rainbow-delimiters-depth-6-face :foreground ,alucard-green)
               (rainbow-delimiters-depth-7-face :foreground ,alucard-yellow)
               (rainbow-delimiters-depth-8-face :foreground ,dark-blue)
               (rainbow-delimiters-unmatched-face :foreground ,alucard-orange)
               ;; rpm-spec
               (rpm-spec-dir-face :foreground ,alucard-green)
               (rpm-spec-doc-face :foreground ,alucard-pink)
               (rpm-spec-ghost-face :foreground ,alucard-purple)
               (rpm-spec-macro-face :foreground ,alucard-yellow)
               (rpm-spec-obsolete-tag-face :inherit font-lock-warning-face)
               (rpm-spec-package-face :foreground ,alucard-purple)
               (rpm-spec-section-face :foreground ,alucard-yellow)
               (rpm-spec-tag-face :foreground ,alucard-cyan)
               (rpm-spec-var-face :foreground ,alucard-orange)
               ;; rst (reStructuredText)
               (rst-level-1 :foreground ,alucard-pink :weight bold)
               (rst-level-2 :foreground ,alucard-purple :weight bold)
               (rst-level-3 :foreground ,alucard-green)
               (rst-level-4 :foreground ,alucard-yellow)
               (rst-level-5 :foreground ,alucard-cyan)
               (rst-level-6 :foreground ,alucard-orange)
               (rst-level-7 :foreground ,dark-blue)
               (rst-level-8 :foreground ,alucard-fg)
               ;; selectrum-mode
               (selectrum-current-candidate :weight bold)
               (selectrum-primary-highlight :foreground ,alucard-pink)
               (selectrum-secondary-highlight :foreground ,alucard-green)
               ;; show-paren
               (show-paren-match-face :background unspecified
                                      :foreground ,alucard-cyan
                                      :weight bold)
               (show-paren-match :background unspecified
                                 :foreground ,alucard-cyan
                                 :weight bold)
               (show-paren-match-expression :inherit match)
               (show-paren-mismatch :inherit font-lock-warning-face)
               ;; shr
               (shr-h1 :foreground ,alucard-pink :weight bold :height 1.3)
               (shr-h2 :foreground ,alucard-purple :weight bold)
               (shr-h3 :foreground ,alucard-green :slant italic)
               (shr-h4 :foreground ,alucard-yellow)
               (shr-h5 :foreground ,alucard-cyan)
               (shr-h6 :foreground ,alucard-orange)
               ;; slime
               (slime-repl-inputed-output-face :foreground ,alucard-purple)
               ;; solaire-mode
               (solaire-default-face :background ,bg2)
               ;; spam
               (spam :inherit gnus-summary-normal-read :foreground ,alucard-orange
                     :strike-through t :slant oblique)
               ;; speedbar (and sr-speedbar)
               (speedbar-button-face :foreground ,alucard-green)
               (speedbar-file-face :foreground ,alucard-cyan)
               (speedbar-directory-face :foreground ,alucard-purple)
               (speedbar-tag-face :foreground ,alucard-yellow)
               (speedbar-selected-face :foreground ,alucard-pink)
               (speedbar-highlight-face :inherit match)
               (speedbar-separator-face :background ,alucard-bg
                                        :foreground ,alucard-fg
                                        :weight bold)
               ;; tab-bar & tab-line (since Emacs 27.1)
               (tab-bar :inherit variable-pitch
                        :foreground ,alucard-purple
                        :background ,alucard-current)
               (tab-bar-tab :foreground ,alucard-pink :background ,alucard-bg
                            :box (:line-width 2 :color ,alucard-bg :style nil))
               (tab-bar-tab-inactive :foreground ,alucard-purple :background ,bg2
                                     :box (:line-width 2 :color ,bg2 :style nil))
               (tab-line :inherit variable-pitch
                         :foreground ,alucard-purple
                         :background ,alucard-current
                         :height 0.92)
               (tab-line-close-highlight :foreground ,alucard-red)
               (tab-line-highlight :weight bold)
               (tab-line-tab :foreground ,alucard-purple :background ,bg2
                             :box (:line-width 4 :color ,bg2 :style nil))
               (tab-line-tab-current :foreground ,alucard-pink :background ,alucard-bg
                                     :box (:line-width 4 :color ,alucard-bg :style nil)
                                     :weight bold)
               (tab-line-tab-group :background ,alucard-comment)
               (tab-line-tab-inactive :inherit tab-line-tab)
               (tab-line-tab-inactive-alternate :background ,bg3)
               (tab-line-tab-modified :slant italic)
               (tab-line-tab-special :foreground ,alucard-green)
               ;; telephone-line
               (telephone-line-accent-active :background ,alucard-bg :foreground ,alucard-pink)
               (telephone-line-accent-inactive :background ,bg2 :foreground ,alucard-purple)
               (telephone-line-unimportant :background ,alucard-bg :foreground ,alucard-comment)
               ;; term
               (term :foreground ,alucard-fg :background ,alucard-bg)
               (term-color-black :foreground ,alucard-bg :background ,alucard-comment)
               (term-color-blue :foreground ,alucard-purple :background ,alucard-purple)
               (term-color-cyan :foreground ,alucard-cyan :background ,alucard-cyan)
               (term-color-green :foreground ,alucard-green :background ,alucard-green)
               (term-color-magenta :foreground ,alucard-pink :background ,alucard-pink)
               (term-color-red :foreground ,alucard-red :background ,alucard-red)
               (term-color-white :foreground ,alucard-fg :background ,alucard-fg)
               (term-color-yellow :foreground ,alucard-yellow :background ,alucard-yellow)
               ;; TeX (auctex)
               (TeX-error-description-error :inherit error)
               (TeX-error-description-tex-said :foreground ,alucard-cyan)
               (TeX-error-description-warning :inherit warning)
               ;; tree-sitter
               (tree-sitter-hl-face:attribute :inherit font-lock-constant-face)
               (tree-sitter-hl-face:comment :inherit font-lock-comment-face)
               (tree-sitter-hl-face:constant :inherit font-lock-constant-face)
               (tree-sitter-hl-face:constant.builtin :inherit font-lock-builtin-face)
               (tree-sitter-hl-face:constructor :inherit font-lock-constant-face)
               (tree-sitter-hl-face:escape :foreground ,alucard-pink)
               (tree-sitter-hl-face:function :inherit font-lock-function-name-face)
               (tree-sitter-hl-face:function.builtin :inherit font-lock-builtin-face)
               (tree-sitter-hl-face:function.call :inherit font-lock-function-name-face
                                                  :weight normal)
               (tree-sitter-hl-face:function.macro :inherit font-lock-preprocessor-face)
               (tree-sitter-hl-face:function.special :inherit font-lock-preprocessor-face)
               (tree-sitter-hl-face:keyword :inherit font-lock-keyword-face)
               (tree-sitter-hl-face:punctuation :foreground ,alucard-pink)
               (tree-sitter-hl-face:punctuation.bracket :foreground ,alucard-fg)
               (tree-sitter-hl-face:punctuation.delimiter :foreground ,alucard-fg)
               (tree-sitter-hl-face:punctuation.special :foreground ,alucard-pink)
               (tree-sitter-hl-face:string :inherit font-lock-string-face)
               (tree-sitter-hl-face:string.special :foreground ,alucard-red)
               (tree-sitter-hl-face:tag :inherit font-lock-keyword-face)
               (tree-sitter-hl-face:type :inherit font-lock-type-face)
               (tree-sitter-hl-face:type.parameter :foreground ,alucard-pink)
               (tree-sitter-hl-face:variable :inherit font-lock-variable-name-face)
               (tree-sitter-hl-face:variable.parameter :inherit tree-sitter-hl-face:variable
                                                       :weight normal)
               ;; undo-tree
               (undo-tree-visualizer-current-face :foreground ,alucard-orange)
               (undo-tree-visualizer-default-face :foreground ,fg2)
               (undo-tree-visualizer-register-face :foreground ,alucard-purple)
               (undo-tree-visualizer-unmodified-face :foreground ,alucard-fg)
               ;; web-mode
               (web-mode-builtin-face :inherit font-lock-builtin-face)
               (web-mode-comment-face :inherit font-lock-comment-face)
               (web-mode-constant-face :inherit font-lock-constant-face)
               (web-mode-css-property-name-face :inherit font-lock-constant-face)
               (web-mode-doctype-face :inherit font-lock-comment-face)
               (web-mode-function-name-face :inherit font-lock-function-name-face)
               (web-mode-html-attr-name-face :foreground ,alucard-purple)
               (web-mode-html-attr-value-face :foreground ,alucard-green)
               (web-mode-html-tag-face :foreground ,alucard-pink :weight bold)
               (web-mode-keyword-face :foreground ,alucard-pink)
               (web-mode-string-face :foreground ,alucard-yellow)
               (web-mode-type-face :inherit font-lock-type-face)
               (web-mode-warning-face :inherit font-lock-warning-face)
               ;; which-func
               (which-func :inherit font-lock-function-name-face)
               ;; which-key
               (which-key-key-face :inherit font-lock-builtin-face)
               (which-key-command-description-face :inherit default)
               (which-key-separator-face :inherit font-lock-comment-delimiter-face)
               (which-key-local-map-description-face :foreground ,alucard-green)
               ;; whitespace
               (whitespace-big-indent :background ,alucard-red :foreground ,alucard-red)
               (whitespace-empty :background ,alucard-orange :foreground ,alucard-red)
               (whitespace-hspace :background ,alucard-current :foreground ,alucard-comment)
               (whitespace-indentation :background ,alucard-orange :foreground ,alucard-red)
               (whitespace-line :background ,alucard-bg :foreground ,alucard-pink)
               (whitespace-newline :foreground ,alucard-comment)
               (whitespace-space :background ,alucard-bg :foreground ,alucard-comment)
               (whitespace-space-after-tab :background ,alucard-orange :foreground ,alucard-red)
               (whitespace-space-before-tab :background ,alucard-orange :foreground ,alucard-red)
               (whitespace-tab :background ,bg2 :foreground ,alucard-comment)
               (whitespace-trailing :inherit trailing-whitespace)
               ;; yard-mode
               (yard-tag-face :inherit font-lock-builtin-face)
               (yard-directive-face :inherit font-lock-builtin-face))))

  (apply #'custom-theme-set-faces
         'alucard
         (let ((expand-with-func
                (lambda (func spec)
                  (let (reduced-color-list)
                    (dolist (col colors reduced-color-list)
                      (push (list (car col) (funcall func col))
                            reduced-color-list))
                    (eval `(let ,reduced-color-list
                             (backquote ,spec))))))
               whole-theme)
           (pcase-dolist (`(,face . ,spec) faces)
             (push `(,face
                     ((((min-colors 16777216)) ; fully graphical envs
                       ,(funcall expand-with-func 'cadr spec))
                      (((min-colors 256))      ; terminal withs 256 colors
                       ,(if alucard-use-24-bit-colors-on-256-colors-terms
                            (funcall expand-with-func 'cadr spec)
                          (funcall expand-with-func 'caddr spec)))
                      (t                       ; should be only tty-like envs
                       ,(funcall expand-with-func 'cadddr spec))))
                   whole-theme))
           whole-theme)))


;;;###autoload
(when load-file-name
  (add-to-list 'custom-theme-load-path
               (file-name-as-directory (file-name-directory load-file-name))))

(provide-theme 'alucard)

;; Local Variables:
;; indent-tabs-mode: nil
;; End:

;;; alucard-theme.el ends here

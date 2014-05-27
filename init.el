(tool-bar-mode 0)
(menu-bar-mode 1)
(setq inhibit-startup-message 1)
(setq initial-scratch-message "")
(column-number-mode 1)
(display-time-mode 1)
(show-paren-mode 1)
(setq ring-bell-function 'ignore)

(setq default-line-spacing 0)
(setq default-fill-column 90)
(setq default-major-mode 'text-mode)
(setq kill-ring-max 200)
(setq require-final-newline t)

(global-font-lock-mode 1)

(transient-mark-mode 1)
(setq scroll-margin 5
      scroll-conservatively 10000)

(show-paren-mode 1)
(setq show-paren-style 'parentheses)
(setq mouse-yank-at-point 1)

(setq visible-bell 0)
(fset 'yes-or-no-p 'y-or-n-p)
(setq resize-mini-windows 0)
(setq enable-recursive-minibuffers 1)

(setq column-number-mode 1)

; file path or buffer name
(setq-default frame-title-format '(buffer-file-name "%f" "%b"))

(setq
   backup-by-copying t      ; don't clobber symlinks
   backup-directory-alist
    '(("." . "~/.saves"))    ; don't litter my fs tree
   delete-old-versions t
   kept-new-versions 6
   kept-old-versions 2
   version-control t)       ; use versioned backups
(setq x-select-enable-clipboard 1)
(setq-default indent-tabs-mode nil)
(setq-default tab-always-indent 0)
(setq-default tab-width 4)

;; (global-linum-mode 1)

;;shortcut
(global-set-key (kbd "C-t") 'set-mark-command)
(global-set-key (kbd "M-`") 'next-multiframe-window)

;;font
(prefer-coding-system 'utf-8)
(set-default-font "Inconsolata 14")
(set-fontset-font "fontset-default" 'unicode "Hiragino Sans GB 14")

;;Packages
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

;; Add in your own as you wish:
(defvar my-packages '(
                      auto-complete
                      yasnippet
                      smex
                      js3-mode
                      emmet-mode
                      less-css-mode
                      flx-ido
                      flx
                      bookmark+
                      base16-theme
                      multiple-cursors
                      projectile
                      magit
                      )
  "A list of packages to ensure are installed at launch.")

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))

(require 'auto-complete)
(require 'auto-complete-config)
(ac-config-default)
(add-to-list 'ac-modes 'less-css-mode)
(add-hook 'less-css-mode-hook 'ac-css-mode-setup)

(require 'yasnippet)
(yas/global-mode 1)

(setq-default ac-sources '(
                           ac-source-yasnippet
                           ac-source-abbrev
                           ac-source-dictionary
                           ac-source-words-in-same-mode-buffers
                           ))

(require 'ibuffer)
(global-set-key ( kbd "C-x C-b ")' ibuffer)
(add-hook 'ibuffer-mode-hook
          '(lambda()
             (ibuffer-auto-mode 1)))
(setq ibuffer-expert 1)

(require 'ido)
(ido-mode t)
(require 'flx-ido)
(flx-ido-mode 1)
(setq ido-use-faces nil)

(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)

(require 'js3-mode)
(add-to-list 'ac-modes 'js3-mode)
(setq-default js3-auto-indent-p 1)
(setq-default js3-enter-indents-newline 1)
(setq-default js3-indent-level 4)
;; (setq-default js3-indent-on-enter-key 1)
(setq-default js3-consistent-level-indent-inner-bracket 1)

;; web dev
(require 'emmet-mode)
(add-hook 'sgml-mode-hook 'emmet-mode)
(add-hook 'css-mode-hook  'emmet-mode)
(add-hook 'emmet-mode-hook (lambda () (setq emmet-indentation 4)))
(setq emmet-move-cursor-between-quotes t)

;; (add-to-list 'auto-mode-alist '("\\.hbs\\'" . web-mode))
;; (defun web-mode-hook ()
;;   "Hooks for Web mode."
;;   (setq web-mode-markup-indent-offset 4)
;; )
;; (add-hook 'web-mode-hook  'web-mode-hook)

(setq sgml-basic-offset 4)
(add-to-list 'auto-mode-alist '("\\.hbs\\'" . sgml-mode))
(add-to-list 'auto-mode-alist '("\\.ejs\\'" . sgml-mode))

(projectile-global-mode)

(require 'base16-eighties-theme)

(setq sr-speedbar-right-side nil)
(setq speedbar-use-images nil)
(setq sr-speedbar-max-width 26)
(setq sr-speedbar-width-x 22)

(make-face 'speedbar-face)
(set-face-font 'speedbar-face "Inconsolata 12")
(setq speedbar-mode-hook '(lambda () (buffer-face-set 'speedbar-face)))

;; (require 'indent-guide)
;; (indent-guide-global-mode)

(require 'bookmark+)

(require 'multiple-cursors)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
(global-unset-key (kbd "M-<down-mouse-1>"))
(global-set-key (kbd "M-<mouse-1>") 'mc/add-cursor-on-click)

(require 'popwin)
(popwin-mode 1)

;; hs minor mode
(add-hook 'js3-mode-hook (lambda()
                      (imenu-add-menubar-index)
                      (hs-minor-mode t)))

(load-file "~/.emacs.d/heel.el")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(bmkp-last-as-first-bookmark-file "~/.emacs.d/bookmarks")
 '(column-number-mode 1)
 '(display-time-mode t)
 '(ibuffer-saved-filter-groups (quote (("datayes" ("cr" (filename . "/cr/")) ("achy" (filename . "achy")) ("yestrap" (filename . "yestrap")) ("docs" (filename . "doc")) ("heel" (filename . "heel")) ("zeus" (filename . "zeus"))))))
 '(ibuffer-saved-filters (quote (("gnus" ((or (mode . message-mode) (mode . mail-mode) (mode . gnus-group-mode) (mode . gnus-summary-mode) (mode . gnus-article-mode)))) ("programming" ((or (mode . emacs-lisp-mode) (mode . cperl-mode) (mode . c-mode) (mode . java-mode) (mode . idl-mode) (mode . lisp-mode)))))))
 '(js3-boring-indentation t)
 '(show-paren-mode t)
 '(sr-speedbar-auto-refresh nil)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

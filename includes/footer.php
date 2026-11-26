<?php $hideGlobalFooter = $hideGlobalFooter ?? false; ?>
    </main>
<?php if (!$hideGlobalFooter): ?>
    <footer class="app-footer">
        <div class="app-footer-inner">
            <span>&copy; <?= date('Y') ?> CCI An Nuur. develop by Sisttem Informasi ITATS</span>
        </div>
    </footer>
<?php endif; ?>
    <script src="/assets/js/app.js" defer></script>
</body>
</html>

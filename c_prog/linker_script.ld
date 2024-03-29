OUTPUT_FORMAT("elf32-littleriscv")
ENTRY(_start)

SECTIONS
{
  PROVIDE( _start = 0x00000000 );
  PROVIDE( _memory_size = 2048); /* 2048 байт */
  PROVIDE( _interrupt_stack_size = 160); /* данный размер позволяет выполнить
                                            обработку двух прерываний */

  .text : {*(.boot) *(.text*)}
  /*
    В скриптах линковщика есть внутренняя переменная, записываемая как '.'
    Эта переменная называется счетчиком адресов. Она хранит текущий адрес в
    памяти.
    В начале файла она инициализируется нулем. Добавляя новые секции, эта
    переменная будет увеличиваться на размер каждой новой секции.
    Если при размещении секций не указывается никакой адрес, они будут размещены
    по текущему значению счетчика адресов.
    Этой переменной можно присваивать значения, после этого, она будет
    увеличиваться с этого значения.
    Подробнее:
      https://home.cs.colorado.edu/~main/cs1300/doc/gnu/ld_3.html#IDX338
  */
  . = ALIGN(4);
  .data : {*(.data*)}
  /*
    Значение, присвоенное глобальному указателю (GP) выходит за границы RAM,
    однако (для архитектуры RISC-V) общепринято присваивать GP значение равное
    началу секции данных, смещенное на 2048 байт вперед.
    Благодаря относительной адресации со смещением в 12 бит, можно адресоваться
    на начало секции данных, а так же по всему адресному пространству вплоть до
    4096 байт от начала секции данных, что сокращает объем требуемых для
    адресации инструкций (практически не используются операции LUI, поскольку GP
    уже хранит базовый адрес и нужно только смещение).
    Подробнее:
      https://groups.google.com/a/groups.riscv.org/g/sw-dev/c/60IdaZj27dY/m/s1eJMlrUAQAJ
  */
  _gbl_ptr = . + 0x800 ;
  . = ALIGN(4);
  /*
    BSS (block started by symbol, неофициально его расшифровывают как
    better save space) — это сегмент, в котором размещаются неинициализированные
    статические переменные. В стандарте Си сказано, что такие переменные
    инициализируются нулем (или NULL для указателей). Когда вы создаете
    статический массив — он должен быть размещен в исполняемом файле.
    Без bss-секции, этот массив должен был бы занимать такой же объем
    исполняемого файла, какого объема он сам. Массив на 1000 байт занял бы
    1000 байт в секции .data.
    Благодаря секции bss, начальные значения массива не задаются, вместо этого
    здесь только записываются названия переменных и их адреса.
    Однако на этапе загрузки исполняемого файла теперь необходимо принудительно
    занулить участок памяти, занимаемый bss-секцией, поскольку статические
    переменные должны быть проинициализированы нулем.
    Таким образом, bss-секция значительным образом сокращает объем исполняемого
    файла (в случае использования неинициализированных статических массивов)
    ценой увеличения времени загрузки этого файла.
    Для того, чтобы занулить bss-секцию, в скрипте заводятся две переменные,
    указывающие на начало и конец bss-секции посредством счетчика адресов.
    Подробнее:
      https://en.wikipedia.org/wiki/.bss
  */
  _bss_start = .;
  .bss : {*(.bss*)}
  _bss_end = .;


  /*=================================
      Секция аллоцированных данных завершена, остаток свободной памяти отводится
      под программный стек, стек прерываний и (возможно) кучу. В соглашении о
      вызовах архитектуры RISC-V сказано, что стек растет снизу вверх, поэтому
      наша цель разместить его в самых последних адресах памяти.
      Поскольку стеков у нас два, в самом низу мы разместим стек прерываний, а
      над ним программный стек. При этом надо обеспечить защиту программного
      стека от наложения на него стека прерываний.
      Однако перед этим, мы должны убедиться, что под программный стек останется
      хотя бы 256 байт (ничем не обоснованное число, взятое с потолка).
      Поскольку указатель стека (SP) должен быть выровнен до 16 байт, мы
      обеспечиваем себе максимум 16 вложенных вызовов.
      Подробнее:
        https://riscv.org/wp-content/uploads/2015/01/riscv-calling.pdf
    =================================
  */

  /* Мы хотим гарантировать, что под стек останется как минимум 256 байт */
  ASSERT(. < (_memory_size - _interrupt_stack_size - 256),
            "Program size is too big")

  /*  Перемещаем счетчик адресов над стеком прерываний (чтобы после мы могли
      использовать его в вызове ALIGN) */
  . = _memory_size - _interrupt_stack_size;

  /*
      Размещаем указатель программного стека так близко к границе стека
      прерываний, насколько можно с учетом требования о выравнивании адреса
      стека до 16 байт.
  */
  _stack_ptr = ALIGN(16) <= _memory_size - _interrupt_stack_size?
                ALIGN(16) : ALIGN(16) - 16;
  ASSERT(_stack_ptr <= _memory_size - _interrupt_stack_size, "SP exceed memory size")

  /*  Перемещаем счетчик адресов в конец памяти (чтобы после мы могли
      использовать его в вызове ALIGN) */
  . = _memory_size;

  /*
      Обычно память имеет размер, кратный 16, но на случай, если это не так, мы
      делаем проверку, после которой мы либо остаемся в самом конце памяти (если
      конец кратен 16), либо поднимаемся на 16 байт вверх от края памяти,
      округленного до 16 в сторону большего значения
  */
  _interrupt_stack_ptr = ALIGN(16) <= _memory_size ? ALIGN(16) : ALIGN(16) - 16;
  ASSERT(_interrupt_stack_ptr <= _memory_size, "ISP exceed memory size")
}